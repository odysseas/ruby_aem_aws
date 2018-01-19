# Copyright 2018 Shine Solutions
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

require_relative 'mixins/healthy_instance_state_verifier'
require_relative 'mixins/metric_verifier'
require_relative 'abstract_component'
require_relative 'component_descriptor'

module RubyAemAws
  module Component
    # Interface to the AWS instance running the Author component of a full-set AEM stack.
    class Author
      include AbstractComponent
      include HealthyInstanceStateVerifier
      include MetricVerifier

      def get_ec2_resource
        @ec2_resource
      end

      def get_descriptor
        @descriptor
      end

      EC2_COMPONENT = 'author-primary'.freeze
      EC2_NAME = 'AEM Author - Primary'.freeze

      # @param stack_prefix AWS tag: StackPrefix
      # @param ec2_resource AWS EC2 resource
      # @return new RubyAemAws::FullSet::Author
      def initialize(stack_prefix, ec2_resource)
        @descriptor = ComponentDescriptor.new(stack_prefix,
                                              EC2Descriptor.new(EC2_COMPONENT, EC2_NAME),
                                              nil)
        @ec2_resource = ec2_resource
      end

      # def get_primary_instance

      # def get_standby_instance

      # def terminate_primary_instance

      # def terminate_standby_instance

      # def wait_until_healthy
    end
  end
end
