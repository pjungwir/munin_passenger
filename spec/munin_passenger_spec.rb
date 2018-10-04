describe 'munin_passenger plugin' do

  before do
    ENV['PASSENGER_ROOT'] = File.dirname(__FILE__) + '/mock'
  end

  it "gives the queue configuration" do
    expect(MuninPassenger::Graphs.queue_config).to eq <<-EOF
graph_category passenger
graph_title Passenger queue
graph_vlabel Requests
_group__vagrant_example__production__queue.label /vagrant/example (production)
_worker_1_sessions.label Worker 1 (PID 4510)
_worker_2_sessions.label Worker 2 (PID 4529)
_worker_3_sessions.label Worker 3 (PID 4548)
_worker_4_sessions.label Worker 4 (PID 4567)
    EOF
  end

  it "gives the queue values" do
    expect(MuninPassenger::Graphs.queue_values).to eq <<-EOF
_group__vagrant_example__production__queue.value 4
_worker_1_sessions.value 1
_worker_2_sessions.value 1
_worker_3_sessions.value 1
_worker_4_sessions.value 1
    EOF
  end

  it "gives the ram configuration" do
    expect(MuninPassenger::Graphs.ram_config).to eq <<-EOF
graph_category passenger
graph_title Passenger memory usage
graph_vlabel Bytes
_worker_1_ram.label Worker 1 (PID 4510)
_worker_2_ram.label Worker 2 (PID 4529)
_worker_3_ram.label Worker 3 (PID 4548)
_worker_4_ram.label Worker 4 (PID 4567)
    EOF
  end

  it "gives the ram values" do
    expect(MuninPassenger::Graphs.ram_values).to eq <<-EOF
_worker_1_ram.value #{40400 * 1024}
_worker_2_ram.value #{24396 * 1024}
_worker_3_ram.value #{24268 * 1024}
_worker_4_ram.value #{23872 * 1024}
    EOF
  end

  it "gives the cpu configuration" do
    expect(MuninPassenger::Graphs.cpu_config).to eq <<-EOF
graph_category passenger
graph_title Passenger CPU
graph_vlabel %
_worker_1_cpu.label Worker 1 (PID 4510)
_worker_2_cpu.label Worker 2 (PID 4529)
_worker_3_cpu.label Worker 3 (PID 4548)
_worker_4_cpu.label Worker 4 (PID 4567)
    EOF
  end

  it "gives the cpu values" do
    expect(MuninPassenger::Graphs.cpu_values).to eq <<-EOF
_worker_1_cpu.value 2
_worker_2_cpu.value 3
_worker_3_cpu.value 2
_worker_4_cpu.value 2
    EOF
  end

  it "gives the processed configuration" do
    expect(MuninPassenger::Graphs.processed_config).to eq <<-EOF
graph_category passenger
graph_title Requests processed
graph_vlabel Requests
_worker_1_processed.label Worker 1 (PID 4510)
_worker_2_processed.label Worker 2 (PID 4529)
_worker_3_processed.label Worker 3 (PID 4548)
_worker_4_processed.label Worker 4 (PID 4567)
    EOF
  end

  it "gives the processed values" do
    expect(MuninPassenger::Graphs.processed_values).to eq <<-EOF
_worker_1_processed.value 139
_worker_2_processed.value 138
_worker_3_processed.value 138
_worker_4_processed.value 138
    EOF
  end

  it "gives the uptime configuration" do
    expect(MuninPassenger::Graphs.uptime_config).to eq <<-EOF
graph_category passenger
graph_title Uptime
graph_vlabel Hours
_worker_1_uptime.label Worker 1 (PID 4510)
_worker_2_uptime.label Worker 2 (PID 4529)
_worker_3_uptime.label Worker 3 (PID 4548)
_worker_4_uptime.label Worker 4 (PID 4567)
    EOF
  end

  it "gives the uptime values" do
    Timecop.travel('Thu Sep 13 20:36:38 PDT 2018') do
      expect(MuninPassenger::Graphs.uptime_values).to eq <<-EOF
_worker_1_uptime.value 9.369166666666667
_worker_2_uptime.value 9.368888888888888
_worker_3_uptime.value 9.368888888888888
_worker_4_uptime.value 9.368888888888888
      EOF
    end
  end

  it "gives the last_used configuration" do
    expect(MuninPassenger::Graphs.last_used_config).to eq <<-EOF
graph_category passenger
graph_title Last used
graph_vlabel Seconds
_worker_1_last_used.label Worker 1 (PID 4510)
_worker_2_last_used.label Worker 2 (PID 4529)
_worker_3_last_used.label Worker 3 (PID 4548)
_worker_4_last_used.label Worker 4 (PID 4567)
    EOF
  end

  it "gives the last_used values" do
    Timecop.travel('Thu Sep 13 20:36:38 PDT 2018') do
      expect(MuninPassenger::Graphs.last_used_values).to eq <<-EOF
_worker_1_last_used.value 33697
_worker_2_last_used.value 33697
_worker_3_last_used.value 33697
_worker_4_last_used.value 33697
      EOF
    end
  end

end
