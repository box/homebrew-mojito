class MojitoWebapp < Formula
  desc "Mojito Webapp, is the server of Mojito: a continuous localization platform"
  homepage "http://mojito.global"
  
  url "https://github.com/box/mojito/releases/download/v0.62/mojito-webapp-0.62.jar"
  sha256 "9496cd1980b9fedf6819dbb7f057e3e43f3688bd6fa2eae119a0adff88074d9d"

  head "git@github.com:box/mojito.git", :using => :git, :branch => "master"

  depends_on :java => "1.7+"

  if build.head?
    depends_on "maven" => :build
  end

  def install
 
    if build.head?
      # build the jar
      system "mvn package -DskipTests"
      libexec.install Dir["webapp/target/mojito-webapp-*.jar"]
    else
      # use downloaded jar
      libexec.install Dir["mojito-webapp-*.jar"]         
    end

    # Create the shell script to execute mojito webapp
    (bin/"mojito-webapp").write <<-EOS.undent
          #!/bin/sh
          java -XX:MaxPermSize=128m -Xmx1024m -Dspring.config.location=#{etc}/mojito/webapp/ -jar #{libexec}/mojito-webapp-*.jar "$@"
    EOS

  end
end
