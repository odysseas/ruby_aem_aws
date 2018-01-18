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
require_relative '../../../../lib/ruby_aem_aws/component/author'

author = RubyAemAws::Component::Author.new(nil, nil)

describe author do
  it_behaves_like 'a health_checker'
end

describe 'Author.healthy?' do
  before do
    @mock_ec2 = double('mock_ec2')

    @author = RubyAemAws::Component::Author.new(@mock_ec2, TEST_STACK_PREFIX)
  end

  it 'runs healthy method' do
    expect { @author.healthy? }.to raise_error(RubyAemAws::NotYetImplementedError)
  end
end
