local card_highlight_ref = Card.highlight
function Card:highlight(is_highlighted)
	self.highlighted = is_highlighted
    if self.highlighted and string.find(self, ability.name, "star") then
		if self.children.use_button then
			self.children.use_button:remove()
		self.children.use_button = nil
		end
		self.children.use_button = UIBox {
			definition = StarCoMod.create_sell_and_switch_buttons(self, {sell = true, use = true}),
			config = {
				align = "cr",
				offset = { x = -0.4, y = 0 },
				parent = self
			}
		}
	else
		card_highlight_ref(self, is_highlighted)
	end
end

