#
# Cookbook:: rsyslog
# Library:: matchers
#
# Copyright:: 2015-2016, Chef Software, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

if defined?(ChefSpec)
  def create_rsyslog_file_input(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rsyslog_file_input, :create, resource_name)
  end
end
