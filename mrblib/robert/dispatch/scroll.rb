# frozen_string_literal: true

class Robert::Dispatch
  ##
  # {Scroll} keeps repeated arrow-key scrolling responsive.
  #
  # Terminals can queue many up/down key-repeat events while a key is held.
  # Robert drains pending input events before each draw, and this module
  # coalesces those arrow-key repeats into a single pending row movement per
  # event-loop tick. Page up/down still scroll immediately because they are
  # explicit larger jumps.
  #
  # Submitting a message returns the chat to follow mode by clearing pending
  # scroll movement before the next response starts streaming.
  module Scroll
    ##
    # Queue scroll movement so repeated arrow-key events are coalesced.
    # @param [Integer] delta
    # @return [void]
    def scroll_later(delta)
      @scroll_delta += delta
      @scroll_delta = [[@scroll_delta, -1].max, 1].min
    end

    ##
    # Apply queued scroll movement to the chat widget.
    # @return [Boolean] true when a scroll movement was applied
    def apply_scroll
      delta = @scroll_delta
      @scroll_delta = 0
      scroll_by(delta)
      true
    end

    ##
    # Apply a scroll movement immediately.
    # @param [Integer] delta
    # @return [void]
    def scroll_now(delta)
      @scroll_delta = 0
      scroll_by(delta)
      redraw!
    end

    ##
    # Return chat scrolling to follow mode after a new message is submitted.
    # @return [void]
    def follow!
      @scroll_delta = 0
    end

    private

    ##
    # Move the chat widget by the given row delta.
    # @param [Integer] delta
    # @return [void]
    def scroll_by(delta)
      delta.abs.times do
        if delta.positive?
          ui.chat.scroll_up
        else
          ui.chat.scroll_down
        end
      end
    end
  end
end
