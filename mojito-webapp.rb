class MojitoWebapp < Formula
  desc "Mojito Webapp, is the server of Mojito: a continuous localization platform"
  homepage "http://mojito.global"
  
  url "https://github.com/box/mojito/releases/download/v0.73/mojito-webapp-0.73.jar"
  sha256 "b6084c5018f06a7b07ceb37aa35f2b158104dc36539113a17f61737571b345ca"

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
