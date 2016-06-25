class MojitoCli < Formula
  desc "Mojito CLI is the command line interface of Mojito: a continuous localization platform"
  homepage "http://opensource.box.com/mojito"
  
  url "https://github.com/box/mojito/releases/download/v0.33/mojito-cli-0.33.jar"
  sha256 "53c0af93fbd512f72fd56d7307cc0d0ab1d23e70ed170496ea7b80ea074c2ea2"

  head "git@github.com:box/mojito.git", :using => :git, :branch => "master"

  depends_on :java => "1.7+"

  if build.head?
    depends_on "maven" => :build
  end

  def install
 
    if build.head?
      # build the jar
      system "mvn package -DskipTests -P!frontend"
      libexec.install Dir["cli/target/mojito-cli-*.jar"]
    else
      # use downloaded jar
      libexec.install Dir["mojito-cli-*.jar"]         
    end

    # Create the shell script to execute mojito cli
    (bin/"mojito").write <<-EOS.undent
          #!/bin/sh
          java -Dspring.config.location=#{etc}/mojito/cli/ -jar #{libexec}/mojito-cli-*.jar "$@"
    EOS

  end
end
