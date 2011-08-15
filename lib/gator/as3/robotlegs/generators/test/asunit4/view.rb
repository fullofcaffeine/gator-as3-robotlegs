module Gator
  module AS3
    module RobotLegs
      module ASUnit4

        class ViewTestGenerator < Task
          include Gator::Project

          define :command => "view",
                 :usage => "generate as3 robotlegs view test CLASS_NAME", :description => "Creates ASUnit4 view test."

          argument :classname

          class_option :impl, :default => false

          def self.source_root
            File.dirname __FILE__
          end

          def generate
            src = project.path(:source, :test, :as3)
            @package_name, @class_name = split_class_name(classname)
            @class_name += "Test"
            @package_name += ".components"
            src = File.join(src, @package_name.split(".").join(File::SEPARATOR)) unless @package_name == ""
            template "view.as.tt", File.join(src, "#{@class_name}.as")
          end

          def generate_implementation
            invoke resolve_subcommand(["test","suite"],["as3","klass"]), [classname]
            return unless options[:impl]
            invoke resolve_subcommand(["robotlegs","view"],["as3","klass"])
          end

          no_tasks {

            def package_name
              @package_name
            end

            def class_name
              @class_name
            end
            
            def instance_name
              @class_name.chomp("Test")
            end

          }

          protected

          def split_class_name(class_name)
            pieces = class_name.split "."
            class_name = pieces.pop
            package_name = pieces.join "."
            return package_name, class_name
          end

        end
      end
    end
  end
end