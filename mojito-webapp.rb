class MojitoWebapp < Formula
  desc "Mojito Webapp, is the server of Mojito: a continuous localization platform"
  homepage "http://opensource.box.com/mojito"
  
  url "https://github.com/box/mojito/releases/download/v0.33/mojito-webapp-0.33.jar"
  sha256 "53c0af93fbd512f72fd56d7307cc0d0ab1d23e70ed170496ea7b80ea074c2ea2"

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
    (bin/"mojito").write <<-EOS.undent
          #!/bin/sh
          java -jar #{libexec}/mojito-webapp-*.jar -Dspring.config.location=/usr/local/etc/mojito/webapp/ "$@"
    EOS

  end
end
