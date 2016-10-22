# For the personnal asset precompilation

Rails.application.config.assets.precompile << Proc.new do |path|
  if path =~ /.*\.(js|css|scss|svg|eot|woff|ttf|gif|png|ico|jpg|jpeg|mp3)\z/ && (path =~ /(active_admin|bourbon|functions|foundation)/) == nil
    full_path = Rails.application.assets.resolve(path).to_path
    app_assets_path = Rails.root.join('app', 'assets').to_path
    if full_path.starts_with? app_assets_path
      Rails.application.config.assets.precompile += %w(path)
      true
    else
      puts "excluding asset: " + full_path
      false
    end
  else
    false
  end
end

Rails.application.config.assets.precompile += %w(websocket_rails/main.js)