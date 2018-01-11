#===============================================================#
  module Configs_Batt
#---------------------------------------------------------------#

    #Posição X do Sprite do Player na Window
    Sprite_player_pos = (640 / 2) - (180 / 2)
    
#---------------------------------------------------------------#

    #Posição X dos Status do Player na Window
    Stats_player_pos  = (640 / 2)
    
#---------------------------------------------------------------#  
  end
#===============================================================#
  class Window_BattleStatus < Window_Base
    def refresh
      self.contents.clear
      @item_max = $game_party.actors.size
      for i in 0...$game_party.actors.size
        actor = $game_party.actors[i]
        actor_x = (i * 160) + Configs_Batt::Stats_player_pos
        draw_actor_name(actor, actor_x, 0)
        draw_actor_hp(actor, actor_x, 32, 120)
        draw_actor_sp(actor, actor_x, 64, 120)
        if @level_up_flags[i]
          self.contents.font.color = normal_color
          self.contents.draw_text(actor_x, 96, 120, 32, "Nível Acima!")
        else
          draw_actor_state(actor, actor_x, 96)
        end
      end
    end
  end
#===============================================================#  
  class Spriteset_Battle
    alias update_position_new update
    def update
      update_position_new
      @actor_sprites[0].x = Configs_Batt::Sprite_player_pos
    end
  end
#===============================================================#
