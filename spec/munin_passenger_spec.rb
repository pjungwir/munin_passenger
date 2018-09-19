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
_pid_4510_sessions.label PID 4510
_pid_4529_sessions.label PID 4529
_pid_4548_sessions.label PID 4548
_pid_4567_sessions.label PID 4567
    EOF
  end

  it "gives the queue values" do
    expect(MuninPassenger::Graphs.queue_values).to eq <<-EOF
_group__vagrant_example__production__queue.value 4
_pid_4510_sessions.value 1
_pid_4529_sessions.value 1
_pid_4548_sessions.value 1
_pid_4567_sessions.value 1
    EOF
  end

  it "gives the ram configuration" do
    expect(MuninPassenger::Graphs.ram_config).to eq <<-EOF
graph_category passenger
graph_title Passenger memory usage
graph_vlabel Bytes
_pid_4510_ram.label PID 4510
_pid_4529_ram.label PID 4529
_pid_4548_ram.label PID 4548
_pid_4567_ram.label PID 4567
    EOF
  end

  it "gives the ram values" do
    expect(MuninPassenger::Graphs.ram_values).to eq <<-EOF
_pid_4510_ram.value #{40400 * 1024}
_pid_4529_ram.value #{24396 * 1024}
_pid_4548_ram.value #{24268 * 1024}
_pid_4567_ram.value #{23872 * 1024}
    EOF
  end

  it "gives the cpu configuration" do
    expect(MuninPassenger::Graphs.cpu_config).to eq <<-EOF
graph_category passenger
graph_title Passenger CPU
graph_vlabel %
_pid_4510_cpu.label PID 4510
_pid_4529_cpu.label PID 4529
_pid_4548_cpu.label PID 4548
_pid_4567_cpu.label PID 4567
    EOF
  end

  it "gives the cpu values" do
    expect(MuninPassenger::Graphs.cpu_values).to eq <<-EOF
_pid_4510_cpu.value 2
_pid_4529_cpu.value 3
_pid_4548_cpu.value 2
_pid_4567_cpu.value 2
    EOF
  end

  it "gives the processed configuration" do
    expect(MuninPassenger::Graphs.processed_config).to eq <<-EOF
graph_category passenger
graph_title Requests processed
graph_vlabel Requests
_pid_4510_processed.label PID 4510
_pid_4529_processed.label PID 4529
_pid_4548_processed.label PID 4548
_pid_4567_processed.label PID 4567
    EOF
  end

  it "gives the processed values" do
    expect(MuninPassenger::Graphs.processed_values).to eq <<-EOF
_pid_4510_processed.value 139
_pid_4529_processed.value 138
_pid_4548_processed.value 138
_pid_4567_processed.value 138
    EOF
  end

  it "gives the uptime configuration" do
    expect(MuninPassenger::Graphs.uptime_config).to eq <<-EOF
graph_category passenger
graph_title Uptime
graph_vlabel Hours
_pid_4510_uptime.label PID 4510
_pid_4529_uptime.label PID 4529
_pid_4548_uptime.label PID 4548
_pid_4567_uptime.label PID 4567
    EOF
  end

  it "gives the uptime values" do
    Timecop.travel('Thu Sep 13 20:36:38 PDT 2018') do
      expect(MuninPassenger::Graphs.uptime_values).to eq <<-EOF
_pid_4510_uptime.value 9.369166666666667
_pid_4529_uptime.value 9.368888888888888
_pid_4548_uptime.value 9.368888888888888
_pid_4567_uptime.value 9.368888888888888
      EOF
    end
  end

  it "gives the last_used configuration" do
    expect(MuninPassenger::Graphs.last_used_config).to eq <<-EOF
graph_category passenger
graph_title Last used
graph_vlabel Seconds
_pid_4510_last_used.label PID 4510
_pid_4529_last_used.label PID 4529
_pid_4548_last_used.label PID 4548
_pid_4567_last_used.label PID 4567
    EOF
  end

  it "gives the last_used values" do
    Timecop.travel('Thu Sep 13 20:36:38 PDT 2018') do
      expect(MuninPassenger::Graphs.last_used_values).to eq <<-EOF
_pid_4510_last_used.value 33697
_pid_4529_last_used.value 33697
_pid_4548_last_used.value 33697
_pid_4567_last_used.value 33697
      EOF
    end
  end

end
