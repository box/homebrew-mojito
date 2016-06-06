class MojitoCli < Formula
  desc ""
  homepage ""

  #url "https://github.com/box/mojito/releases/download/v0.33/mojito-cli-0.33.jar"
  #sha256 "53c0af93fbd512f72fd56d7307cc0d0ab1d23e70ed170496ea7b80ea074c2ea2"

  url "git@github.com:box/mojito.git", :using => :git, :tag => "v0.33"
  version "0.33"

  head "git@github.com:box/mojito.git", :using => :git, :branch => "master" # , :tag => "v0.33"

  #depends_on :java => "1.7+"
  depends_on "maven" => :build

  def install

    # building the jar for now but we probably want to get it built directly
    system "mvn package -DskipTests -P!frontend"
    libexec.install Dir["cli/target/mojito-cli-*.jar"]

    # Create the shell script to execute mojito cli
    (bin/"mojito").write <<-EOS.undent
          #!/bin/sh
          java -jar #{libexec}/mojito-cli-*.jar "$@"
    EOS

  end

end
