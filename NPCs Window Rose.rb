#==============================================================================#
#-----|                        NPCs_Window_Rose                       |--------#
#==============================================================================#

#   Autor: Felipe Carneiro (FelipeFalcon)         Vers�o: 1.0.0 (16/12/2017)   #
#   Licen�a: https://creativecommons.org/licenses/by/4.0/legalcode             #

#==============================================================================#
     
#   Este script permite mostrar uma Window, que mostra determinados eventos    #
#   que ser�o marcados com c�digos em seus nomes. 

#   � poss�vel mostrar at� 18 eventos escolhidos, acima disso o sistema n�o    #
#   mostra.

#   A janela foi anexada aos mapas, para abri-la/fecha-la use o comando por    #
#   por eventos:                                                               #

#   $window_npcs_rose.open                                                     #
#   $window_npcs_rose.close                                                    #

#   Voc� pode montar um menu por eventos que a abra, libere sua criatividade.  #

#==============================================================================#
#-----|                M�dulo de Configura��es B�sicas                 |-------#
#==============================================================================#
module NPCs_Rose
  
  Window_Width_Size = 320      # Tamanho da janela: 320 � o m�nimo aconselh�vel
  
  Caracter = "@"               # Caracter no nome do evento que o far� aparecer
  
#==============================================================================#
# | T�tulos:                                                                  |#

#   T�tulos s�o o o que caracterizam os NPCs, � poss�vel adicionar novos.     |#
#   Para isso copie o moldee cole na linha de baixo, n�o esque�a da v�rgula.  |#
#   (O �ltimo n�o deve ter v�rgula ap�s)                                      |#

#   Voc� deve escolher um outro caractere mostrar o t�tulo definido.          |#
#   � poss�vel definir o caractere, t�tulo e a cor que o mesmo ir� ter.       |#

#------------------------------------------------------------------------------#
# | Exemplo =>  ["&","Teste, Color.new(255,255,255,255)]                      |#
#------------------------------------------------------------------------------#
# | Exemplo =>  O primeiro � o caractere, o segundo o texto e o terceiro a cor|#
# |             A cor n�o � obrigat�ria, e deve ser em RGB.                   |#
#------------------------------------------------------------------------------#

#==============================================================================#
#-----|                             T�TULOS                             |------#
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
#               A PARTIR DAQUI N�O EDITE, SE N�O SOUBER QUE EST�
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
#-----|          GameEvent - Adi��o m�todo para pegar nomes           |--------#
#==============================================================================#
class Game_Event < Game_Character
#------------------------------------------------------------------------------# 
  def name_rose
    @event.name
  end
#------------------------------------------------------------------------------# 
end

#==============================================================================#
#-----|          Scene_Map - Adi��o da Window a todos os mapas        |--------#
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

