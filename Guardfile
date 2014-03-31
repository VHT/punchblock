group 'rspec' do
  guard 'rspec', cmd: 'bundle exec rspec' do
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')  { "spec/" }
  end
end

group 'benchmarks' do
  guard 'rake', task: 'benchmark', run_on_start: false do
    watch(/benchmarks\/*/)
  end
end
