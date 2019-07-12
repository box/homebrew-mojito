class MojitoWebapp < Formula
  desc "Mojito Webapp, is the server of Mojito: a continuous localization platform"
  homepage "http://mojito.global"

  url "https://github.com/box/mojito/releases/download/v0.99/mojito-webapp-0.99.jar"
  sha256 "9b9457c56f70c76c4450fabc1bda0e4e4b346a4507a5d1adfed416136c7d1f24"

  head "git@github.com:box/mojito.git", :using => :git, :branch => "master"

  depends_on :java => "1.8"

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
    (bin/"mojito-webapp").write <<~EOS
          #!/bin/sh
          java -XX:MaxPermSize=128m -Xmx1024m -Dspring.config.location=#{etc}/mojito/webapp/ -jar #{libexec}/mojito-webapp-*.jar "$@"
    EOS

  end
end
