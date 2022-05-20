require 'os'
require 'open3'

def env_has_key(key)
	return (ENV[key] == nil || ENV[key] == "") ? nil : ENV[key]
end

def get_version(component_version,config_version)
    return config_version == nil ? component_version : config_version
end

component_node_version = env_has_key("AC_SELECTED_NODE_VERSION") || "lts"
config_node_version = env_has_key("AC_NODE_JS_VERSION")
selected_node_version = get_version(component_node_version,config_node_version)
puts "Selected node version is #{selected_node_version}"

def run_command(command)
    puts "@@[command] #{command}"
    status = nil
    stdout_str = nil
    stderr_str = nil
    Open3.popen3(command) do |stdin, stdout, stderr, wait_thr|
        stdout.each_line do |line|
            puts line
        end
        stdout_str = stdout.read
        stderr_str = stderr.read
        status = wait_thr.value
    end
  
    unless status.success?
        abort(stderr_str)
    end
end

if OS.linux?
    run_command("n #{selected_node_version}")
elsif OS.mac?
    run_command("sudo n #{selected_node_version}")
else
    abort("Unexpected OS")
end
