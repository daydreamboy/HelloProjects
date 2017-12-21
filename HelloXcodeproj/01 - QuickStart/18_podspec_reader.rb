require 'cocoapods-core'

class PodspecReader

  # the attributes which auto created
  IGNORED_KEYS = [
      'name',
      'summary',
      'description',
  ].freeze

  # the attributes should set by force_attributes, can't be merged from
  FORCED_KEYS = [
      'header_dir',
      'homepage',
      'requires_arc',
      'source',
      'version',
  ].freeze

  def self.create_podspec_json(podspec_name, podspec_json_dir, podspec_paths, force_attributes)

    # For Test
    # podspec_paths.each do |podspec_path|
    #   podspec_dir = File.expand_path('..', podspec_path)
    #   podspec_name = File.basename(podspec_path)
    #
    #   File.open("#{podspec_dir}/#{podspec_name}.json", 'w') do |file|
    #     file.puts PodspecReader.from_file(podspec_path).to_json
    #   end
    #
    # end

    spec = include_podspecs(podspec_name, podspec_paths, force_attributes)

    # pp spec.attributes_hash

    path = "#{podspec_json_dir}/#{podspec_name}.podspec.json"
    File.open(path, 'w') do |file|
      file.puts spec.to_json
    end

    path
  end

  def self.from_file(path, subspec_name = nil)
    path = Pathname.new(path)
    unless path.exist?
      raise Informative, "No podspec exists at path `#{path}`."
    end

    string = File.open(path, 'r:utf-8', &:read)
    # Work around for Rubinius incomplete encoding in 1.9 mode
    if string.respond_to?(:encoding) && string.encoding.name != 'UTF-8'
      string.encode!('UTF-8')
    end

    from_string(string, path, subspec_name)
  end

  def self.from_string(spec_contents, path, subspec_name = nil)
    path = Pathname.new(path)
    spec = nil
    Dir.chdir(path.parent.directory? ? path.parent : Dir.pwd) do
      case path.extname
        when '.podspec'
          spec = ::PodspecReader._eval_podspec(spec_contents, path)
          unless spec.is_a?(Pod::Specification)
            raise Informative, "Invalid podspec file at path `#{path}`."
          end
        when '.json'
          spec = Pod::Specification.from_json(spec_contents)
        else
          raise Informative, "Unsupported specification format `#{path.extname}`."
      end
    end
    spec.defined_in_file = path
    spec
  end

  def self._eval_podspec(string, path)
    eval(string, nil, path.to_s)
  rescue Exception => e
    message = "Invalid `#{path.basename}` file: #{e.message}"
    raise message
  end

  def self.merge_two_podspecs(podspec1, podspec2, force_attributes)

    # pp(podspec1.attributes_hash)
    # pp(podspec2.attributes_hash)

    # podspec2 => podspec1
    attributes1 = podspec1.attributes_hash
    attributes2 = podspec2.attributes_hash

    FORCED_KEYS.each do |key|
      if attributes2.has_key?(key) && !force_attributes.has_key?(key)
        Log.w "attribute #{key} can't be merged from #{podspec2}. Please set it by force_attributes."
      end
    end

    IGNORED_KEYS.each do |key|
      attributes2.delete(key)
    end

    merge_connectors = { 'prefix_header_contents' => "\n" }

    merged_hash = Collection.merge_hash(attributes1, attributes2, merge_connectors)
    # pp(merged_hash)

    podspec1.attributes_hash = merged_hash
    podspec1
  end

  def self.include_podspecs(name, podspec_paths, force_attributes)

    all_specs = []
    default_settings = {
        'name' => "#{name}",
        'summary' => "Auto-generated for #{name}. DON'T modify it manually!",
        'description' => "Auto-generated from podspecs #{podspec_paths}",
    }
    spec = Pod::Specification.from_hash(default_settings)
    all_specs.push(spec)

    podspec_paths.each do |podspec_path|
      spec_to_merge = PodspecReader.from_file(podspec_path)
      all_specs.push(spec_to_merge)

      spec = PodspecReader.merge_two_podspecs(spec, spec_to_merge, force_attributes)
    end

    PodspecReader::IGNORED_KEYS.each do |key|
      force_attributes.delete(key)
    end
    spec.attributes_hash.merge!(force_attributes)
    spec.subspecs = PodspecReader.merge_subspec(all_specs, force_attributes)

    PodspecReader.remove_common_of_xcconfig!(spec)
    spec
  end

  def self.remove_common_of_xcconfig!(spec)

    spec.attributes_hash['xcconfig'].each do |k, v|

      if !spec.attributes_hash['pod_target_xcconfig'].nil? && spec.attributes_hash['pod_target_xcconfig'].has_key?(k)
        if spec.attributes_hash['pod_target_xcconfig'][k] == v
          spec.attributes_hash['pod_target_xcconfig'].delete(k)
        else
          Log.w "xcconfg and pod_target_xcconfig have same key `#{k}`, but values are different. Please check #{spec.attributes_hash['name']} podspec."
        end
      end

      if !spec.attributes_hash['user_target_xcconfig'].nil? && spec.attributes_hash['user_target_xcconfig'].has_key?(k)
        if spec.attributes_hash['user_target_xcconfig'][k] == v
          spec.attributes_hash['user_target_xcconfig'].delete(k)
        else
          Log.w "xcconfg and pod_target_xcconfig have same key `#{k}`, but values are different. Please check #{spec.attributes_hash['name']} podspec."
        end
      end
    end

  end

  def self.merge_subspec(podspecs, force_attributes)

    # mapping all podspecs has same named subspecs
    # {
    #   subspec_name1 => [spec1, spec2], # spec1 and spec2 have same subspec `subspec_name1`
    #   subspec_name2 => [spec1, spec2, spec3], # spec1, spec2, spec3 have same subspec `subspec_name2`
    # }
    intersection = {}

    # mapping all podspecs has a sole named subspecs
    # {
    #   subspec_name1 => [spec1],
    #   subspec_name2 => [spec2], # array must have only one item
    # }
    exclusion = {}

    podspecs.each do |spec|
      spec.subspecs.each do |subspec|

        subspec_name = subspec.attributes_hash['name']
        if exclusion.has_key?(subspec_name)
          if intersection[subspec_name].nil?
            intersection[subspec_name] = exclusion[subspec_name] + [subspec]
          else
            intersection[subspec_name] += exclusion[subspec_name] + [subspec]
          end

          exclusion.delete(subspec_name)
        else
          exclusion[subspec_name] = [subspec]
        end

      end
    end

    # dump_object(intersection)
    # dump_object(exclusion)

    all_subspecs = []

    exclusion.each do |name, specs|
      if specs.count == 1
        attributes = specs[0].attributes_hash
        subspec = Pod::Specification.from_hash(attributes)
        subspec.attributes_hash['name'] = name
        # podspec.json must need `platforms`
        subspec.attributes_hash['platforms'] = force_attributes['platforms']
        all_subspecs.push(subspec)
      else
        Log.e "#{specs} should have only one spec!"
        raise "#{specs} should have only one spec!"
      end
    end

    intersection.each do |name, specs|
      subspec = Pod::Specification.new
      subspec.attributes_hash['name'] = name
      # podspec.json must need `platforms`
      subspec.attributes_hash['platforms'] = force_attributes['platforms']

      specs.each do |spec|
        subspec = PodspecReader.merge_two_podspecs(subspec, spec, {})
      end

      all_subspecs.push(subspec)
    end

    # all_subspecs.each do |subspec|
    #   dump_object(subspec.attributes_hash)
    # end

    all_subspecs
  end
end
