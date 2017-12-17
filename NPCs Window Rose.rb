#==============================================================================#
#-----|                        NPCs_Window_Rose                       |--------#
#==============================================================================#

#   Autor: Felipe Carneiro (FelipeFalcon)         Versão: 1.0.0 (16/12/2017)   #
#   Licença: https://creativecommons.org/licenses/by/4.0/legalcode             #

#==============================================================================#
     
#   Este script permite mostrar uma Window, que mostra determinados eventos    #
#   que serão marcados com códigos em seus nomes. 

#   É possível mostrar até 18 eventos escolhidos, acima disso o sistema não    #
#   mostra.

#   A janela foi anexada aos mapas, para abri-la/fecha-la use o comando por    #
#   por eventos:                                                               #

#   $window_npcs_rose.open                                                     #
#   $window_npcs_rose.close                                                    #

#   Você pode montar um menu por eventos que a abra, libere sua criatividade.  #

#==============================================================================#
#-----|                Módulo de Configurações Básicas                 |-------#
#==============================================================================#
module NPCs_Rose
  
  Window_Width_Size = 320      # Tamanho da janela: 320 é o mínimo aconselhável
  
  Caracter = "@"               # Caracter no nome do evento que o fará aparecer
  
#==============================================================================#
# | Títulos:                                                                  |#

#   Títulos são o o que caracterizam os NPCs, é possível adicionar novos.     |#
#   Para isso copie o moldee cole na linha de baixo, não esqueça da vírgula.  |#
#   (O último não deve ter vírgula após)                                      |#

#   Você deve escolher um outro caractere mostrar o título definido.          |#
#   É possível definir o caractere, título e a cor que o mesmo irá ter.       |#

#------------------------------------------------------------------------------#
# | Exemplo =>  ["&","Teste, Color.new(255,255,255,255)]                      |#
#------------------------------------------------------------------------------#
# | Exemplo =>  O primeiro é o caractere, o segundo o texto e o terceiro a cor|#
# |             A cor não é obrigatória, e deve ser em RGB.                   |#
#------------------------------------------------------------------------------#

#==============================================================================#
#-----|                             TÍTULOS                             |------#
#==============================================================================#

  Titles = [  
           ["$","Mercador(a)", Color.new(217,156,76,255)],
           ["#","Viajante", Color.new(76,217,143,255)],
           ["%","???"] 
           ]
end


#==============================================================================#
#==============================================================================#
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/#
#------------------------------------------------------------------------------#
#               A PARTIR DAQUI NÃO EDITE, SE NÃO SOUBER QUE ESTÁ
#                                    FAZENDO!
#------------------------------------------------------------------------------#
#\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/\/#
#==============================================================================#
#==============================================================================#



#==============================================================================#
#-----|                    Window - Janela de NPCs                   |---------#
#==============================================================================#
class Window_NPCs_Rose < Window_Base
#------------------------------------------------------------------------------# 
  include NPCs_Rose
#------------------------------------------------------------------------------# 
  def initialize
    super(0, 0, Window_Width_Size, Graphics.height)
    self.x -= self.width
    refresh
  end
#------------------------------------------------------------------------------# 
  def refresh
    contents.clear
    contents.font.color.set(Color.new(221,159,171,255))
    contents.font.bold = true
    contents.font.size = 22
    draw_text(Rect.new(-10,0,width,20),"- -- --- NPCs --- -- -",1)
    memorize_and_create_list_events
  end
#------------------------------------------------------------------------------# 
  def memorize_and_create_list_events
    order_list = 0
    reset_font_settings
    colun = 0
    for i in 1..$game_map.events.length
      event_name_r = $game_map.events[i].name_rose
      if event_name_r.include? Caracter
        order_list += 1 
        colun += self.width/2-4 if order_list > 9
        order_list = 1 if order_list > 9
          for i2 in 0..Titles.length - 1 
            if event_name_r.include? Titles[i2][0]
              event_name_r = $game_map.events[i].name_rose.delete(Titles[i2][0])
              contents.font.size = 14
              contents.font.bold = true
              contents.font.color.set(Titles[i2][2]) if Titles[i2][2] != nil
              draw_text(Rect.new(32+colun,(order_list-1)*42+39,width,20), Titles[i2][1], 0)
            end
          end
        reset_font_settings
        contents.font.size = 22
        draw_character($game_map.events[i].character_name, $game_map.events[i].character_index, 14+colun, (order_list-1)*42+54)
        draw_text_ex(32+colun,(order_list-1)*42+20, event_name_r.delete(Caracter))
      end
    end
  end
#------------------------------------------------------------------------------# 
  def draw_text_ex(x, y, text)
    text = convert_escape_characters(text)
    pos = {x: x, y: y, new_x: x, height: calc_line_height(text)}
    process_character(text.slice!(0, 1), text, pos) until text.empty?
  end
#------------------------------------------------------------------------------# 
  def open
    refresh
      loop do
        break if self.x >= 0
        self.x += 5
        Graphics.update
      end
  end
#------------------------------------------------------------------------------# 
  def close
    loop do
      break if self.x <= -self.width
      self.x -= 5
      Graphics.update
    end
  end
end

#==============================================================================#
#-----|          GameEvent - Adição método para pegar nomes           |--------#
#==============================================================================#
class Game_Event < Game_Character
#------------------------------------------------------------------------------# 
  def name_rose
    @event.name
  end
#------------------------------------------------------------------------------# 
end

#==============================================================================#
#-----|          Scene_Map - Adição da Window a todos os mapas        |--------#
#==============================================================================#
class Scene_Map < Scene_Base
#------------------------------------------------------------------------------# 
   alias initialize_rnpc initialize
   def initialize
     initialize_rnpc
     $window_npcs_rose = Window_NPCs_Rose.new
   end
#------------------------------------------------------------------------------# 
end

