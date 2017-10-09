def update
    if $game_map.events[@id].distance_x_from($game_player.x) >= 16  ||
       $game_map.events[@id].distance_x_from($game_player.x) <= -16 ||
       $game_map.events[@id].distance_y_from($game_player.y) >= 16  ||
       $game_map.events[@id].distance_y_from($game_player.y) <= -16
       $game_map.events[@id].set_opacity_a(0) if @opa != 0
       @opa = 0
       return
     else
       $game_map.events[@id].set_opacity_a(nil) if @opa != nil
       @opa = nil
     end
    return if @event.name.include? "[FIX]"
    super
    check_event_trigger_auto
    return unless @interpreter
    @interpreter.setup(@list, @event.id) unless @interpreter.running?
    @interpreter.update
  end
