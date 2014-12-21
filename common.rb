#lock '3.2.1'

set :keep_releases, 5

namespace :deploy do

  task :fetch_parameters_yml do
    on roles(:daemon) do
        execute "ln -s #{shared_path}/config/parameters.yml #{release_path}/config/"
    end
  end

  task :restart_daemon do
    on roles(:daemon) do
      execute "supervisorctl restart #{fetch(:daemon_name)}"
    end
  end

  task :upload_vendors do
    puts "=========================================================="
    custom_upload("./vendor", "#{release_path}")
    puts "=========================================================="
  end

  def custom_upload(location, target, exclude = [".git"])
    on roles(:all) do
      r = Random.rand(10000000..100000000)
      tmp_file = "custom-upload-tmp-#{r}.tar.gz"
      puts "Uploading #{location} to #{target} with temporary file #{tmp_file}"
      execute "mkdir -p #{target}"
      system "tar -c -z --exclude=" + exclude.join(" --exclude=") + " -f #{tmp_file} -C \"$(dirname \"#{location}\")\" \"$(basename \"#{location}\")\""
      upload! "#{tmp_file}", "#{target}/#{tmp_file}"
      execute "cd #{target} && tar -xzf #{tmp_file} && rm #{tmp_file}"
      system "rm #{tmp_file}"
    end
  end

end
