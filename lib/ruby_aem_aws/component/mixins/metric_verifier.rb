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

module RubyAemAws
  # Mixin for checking that an instance has associated CloudWatch metrics.
  module MetricVerifier
    # @param metric_name the name of the metric to check for.
    # @return true if the instance has a metric with @metric_name.
    def metric?(metric_name)
      !metric_instances(metric_name).empty?
    end

    # @param metric_name the name of the metric to check for.
    # @return an array of instance_ids that have a metric with @metric_name.
    def metric_instances(metric_name)
      instances_with_metric = []
      instances = get_all_instances
      instances.each do |instance|
        next if instance.nil?
        instance_id = instance.instance_id
        metrics = @cloud_watch_client.list_metrics(namespace: 'AWS/EC2',
                                                   metric_name: metric_name,
                                                   dimensions: [
                                                     name: 'InstanceId',
                                                     value: instance_id
                                                   ]).metrics
        instances_with_metric.push(instance_id) unless metrics.empty?
      end
      instances_with_metric
    end
  end
end