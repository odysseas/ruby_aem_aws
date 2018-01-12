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

require_relative '../spec_helper'
require 'ruby_aem_aws'

aem_aws = init_client
author_dispatcher = aem_aws.full_set('sandpit-doug').author_dispatcher

describe 'AuthorDispatcher' do
  before do
  end

  after do
  end

  it 'is healthy' do
    expect(author_dispatcher.healthy?).to eq(true)
  end
end
