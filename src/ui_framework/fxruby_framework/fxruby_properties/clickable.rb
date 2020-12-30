module Clickable

  def add_click_event(&block_event)
    @ui_object.connect(SEL_COMMAND) do
      |sender, sel, data|
      block_event.call(sender, sel, data)
    end
  end

end