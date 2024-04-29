defmodule BundesbattleWeb.BaselHTML do
  use BundesbattleWeb, :html

  def index(assigns) do
    ~H"""
    Hello!
    <div id="map" data-lat="47.5461561" data-lng="7.5861434" phx-update="ignore" class="w-full h-80 my-16 rounded-md shadow">
      <a href="https://maps.app.goo.gl/tA5aBKeYRgEoLUN79">
        <b>ManaBar</b>
        <br /> Güterstrasse 99 <br /> 4053 Basel
      </a>
    </div>
    """
  end
end
