module Goggles

  def execute_script(url, script)
    @watir.goto url
    @watir.cookies.clear
    @watir.refresh

    eval(File.read(script))
  end
end
