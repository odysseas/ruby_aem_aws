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

require_relative '../../spec_helper'
require_relative 'examples/health_checker'
require_relative '../../../../lib/ruby_aem_aws/component/author_publish_dispatcher'

author_publish_dispatcher = RubyAemAws::Component::AuthorPublishDispatcher.new(nil, nil)

describe author_publish_dispatcher do
  it_behaves_like 'a health flagged component'
end

describe 'AuthorPublishDispatcher.healthy?' do
  before do
    @instance_component = RubyAemAws::Component::AuthorPublishDispatcher::EC2_COMPONENT
    @instance_name = RubyAemAws::Component::AuthorPublishDispatcher::EC2_NAME
    @instance_filter = [
      { StackPrefix: TEST_STACK_PREFIX },
      { Component: @instance_component },
      { Name: @instance_name }
    ].freeze
    @instance_1_id = 'i-00525b1a281aee5b9'.freeze
    @instance_2_id = 'i-00525b1a281aee5b7'.freeze
    @instance_3_id = 'i-00525b1a281aee5b5'.freeze

    @mock_ec2 = double('mock_ec2')

    @instances = []

    @author_dispatcher = RubyAemAws::Component::AuthorPublishDispatcher.new(@mock_ec2, TEST_STACK_PREFIX)
  end

  it 'verifies EC2 running instance' do
    add_instance(@instance_1_id, INSTANCE_STATE_HEALTHY)

    expect(@author_dispatcher.healthy?).to equal true
  end

  it 'verifies EC2 not-running instance' do
    add_instance(@instance_1_id, INSTANCE_STATE_UNHEALTHY)

    expect(@author_dispatcher.healthy?).to equal false
  end

  it 'verifies EC2 running instance (one of many)' do
    add_instance(@instance_1_id, INSTANCE_STATE_HEALTHY)
    add_instance(@instance_2_id, INSTANCE_STATE_HEALTHY, Name: 'bob')
    add_instance(@instance_3_id, INSTANCE_STATE_UNHEALTHY, Component: 'bob')

    expect(@author_dispatcher.healthy?).to equal true
  end

  it 'verifies EC2 non-running instance (one of many)' do
    add_instance(@instance_1_id, INSTANCE_STATE_UNHEALTHY)
    add_instance(@instance_2_id, INSTANCE_STATE_HEALTHY, Name: 'bob')
    add_instance(@instance_3_id, INSTANCE_STATE_UNHEALTHY, Component: 'bob')

    expect(@author_dispatcher.healthy?).to equal false
  end

  private

  # Intentional replication of AWS instance filter logic for use by mock EC2 Resource.
  def filter_instances(instances, filters)
    filtered = instances
    # Include only instances that match all filters.
    filters.each do |filter|
      key, value = filter.first
      filtered = filtered.select { |i|
        found_tag = i.tags.find { |t|
          t.key == key.to_s
        }
        next if found_tag.nil?
        found_tag.value == value
      }
    end
    filtered
  end

  def add_instance(id, state, tags = {})
    # Add default tags.
    tags[:StackPrefix] = TEST_STACK_PREFIX if tags[:StackPrefix].nil?
    tags[:Component] = @instance_component if tags[:Component].nil?
    tags[:Name] = @instance_name if tags[:Name].nil?

    @instances.push(mock_ec2_instance(id, state, tags))
    allow(@mock_ec2).to receive(:instances) { filter_instances(@instances, @instance_filter) }
  end
end