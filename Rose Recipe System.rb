#==============================================================================#
#-----|                        Rose Recipe System                     |--------#
#==============================================================================#

#   Autor: Felipe Carneiro (FelipeFalcon)         Versão: 1.0.0 (15/12/2017)   #
#   Licença: https://creativecommons.org/licenses/by/4.0/legalcode             #

#==============================================================================#
     
#   Este script permite criar receitas, com utilização de itens para criar     #
#   outros itens. (Dando no mesmo que fusão/transformação, etc)                #
     
#   É possível escolher até 9 itens em quantidade desejada de cada um, que     #
#   serão transformados em um único item de resultado com quantidade definida. #

#   Para chamar a Cena de criação de itens utilize em um evento o comando de   #
#   chamar script:                                                             #

#   SceneManager.call(Scene_Crafter_Rose)                                      #

#   As receitas devem ficar dentro do módulo mais abaixo na seção de receitas. #      #
#   As receitas também devem seguir a ordem, [0],[1],[2],...                   #

#   Siga a receita exemplo ou outra receita feita, para criar as suas.         #

#==============================================================================#
#-----|                Módulo de Configurações Básicas                 |-------#
#==============================================================================#
module Config_Rose_Basic
  
  Sound_Sucess_R = ["Decision2", 100, 70] #Som de Sucesso[SE], (nome,vol.,veloc)
  
  Sound_Error_R = ["Buzzer1", 90, 90]     #Som de Erro   [SE], (nome,vol.,veloc)
  
end
#==============================================================================#
#-----|                        Módulo de Receitas                      |-------#
#==============================================================================#
module Recipes_Rose
  
# | Criação da Matriz de Receitas  (Não apague)                               |#
    Recipes_r = []

#==============================================================================#
# | Receita Exemplo:                                                          |#

#   1 ===|     Recipes_r[0] = []                                              |#
#   2 ===|     Recipes_r[0][0] = [ [1,10], [2,1] ]                            |#
#   3 ===|     Recipes_r[0][1] = [3,1]                                        |#
#   4 ===|     Recipes_r[0][2] =  100                                         |#
#------------------------------------------------------------------------------#
# | 1 =>  Array que conterá todas instruções da   RECEITA   0                 |#
#------------------------------------------------------------------------------#
# | 2 =>  Sub-Array contendo os "ingredientes" [ID, Quatidade]                |#

# | 2 =>  Na receita exemplo é definido: [[Item1_ID, 10un.],[Item2_ID, 1un.]] |#

# | 2 =>  Recomendável no máximo até 9 "ingredientes", separe-os por vírgula  |#
#------------------------------------------------------------------------------#
# | 3 =>  Definido o Item que será resultado da criação [ID, Quantidade]      |#

# | 3 =>  Obrigatório somente um tipo de Item por resultado                   |#
#------------------------------------------------------------------------------#
# | 4 =>  Taxa de sucesso para criação: 0....100             (0%...100%)      |#
#------------------------------------------------------------------------------#

#==============================================================================#
#-----|                             RECEITAS                            |------#
#==============================================================================#

#-----| Receita 0
  Recipes_r[0] = []
  Recipes_r[0][0] = [ [1,4] ]          
  Recipes_r[0][1] =  [3,1]                
  Recipes_r[0][2] = 100
  
#-----| Receita 1
  Recipes_r[1] = []
  Recipes_r[1][0] = [ [1,1], [2,3] ]
  Recipes_r[1][1] =  [5,1] 
  Recipes_r[1][2] = 80

#-----| Receita 2
  Recipes_r[2] = []
  Recipes_r[2][0] = [ [2,4], [4,2], [12,1] ]
  Recipes_r[2][1] =  [9,1] 
  Recipes_r[2][2] = 40
  
#-----| Receita 3
  Recipes_r[3] = []
  Recipes_r[3][0] = [ [1,1], [2,1], [3,1], [4,1], [5,10], [6,10], [7,10], [8,10], [9,8] ]
  Recipes_r[3][1] =  [11,1] 
  Recipes_r[3][2] = 100
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
#-----|             Window - Escolha de Criar ou Cancelar            |---------#
#==============================================================================#
class Window_ConfirmCraft < Window_Command
  def initialize
    super(0, 0)
    self.x = (Graphics.width - width) / 2
    self.y = (Graphics.height - height) / 2
    self.openness = 0
    self.z = 112
    alignment = 1
    open
  end
#------------------------------------------------------------------------------#  
  def col_max
    return 2
  end
#------------------------------------------------------------------------------#  
  def standard_padding
    return 8
  end
#------------------------------------------------------------------------------#  
  def spacing
    return 12
  end
#------------------------------------------------------------------------------#  
  def window_width
    return 368
  end
#------------------------------------------------------------------------------#  
  def window_height
    return 40
  end
#------------------------------------------------------------------------------#  
  def alignment
    return 1
  end
#------------------------------------------------------------------------------#  
  def make_command_list
    add_command("Confirmar", :to_confirm)
    add_command(Vocab::cancel,   :cancel)
  end
end

#==============================================================================#
#----|   Windows - Janelas de Texto (Informações, Centro de Criação, ...)   |--#
#==============================================================================#
class Window_Name_Rose < Window_Base
#------------------------------------------------------------------------------#
  def initialize(x, y, width, height, name, color)
    super(x, y, width, height)
    @name_w = name
    @color_r = color
    self.z = 112
    refresh
  end
#------------------------------------------------------------------------------#  
  def standard_padding
    return 6
  end
#------------------------------------------------------------------------------#  
  def refresh
    contents.clear
    change_color(text_color(@color_r))
    draw_text(Rect.new(-3,0,self.width, 26),@name_w,1)
  end
end

#==============================================================================#
#-----|          Window - Barrinha de Sintetização e Resultado        |--------#
#==============================================================================#
class Window_Bar_Rose < Window_Base
#------------------------------------------------------------------------------#
  include Recipes_Rose
  include Config_Rose_Basic
#------------------------------------------------------------------------------#
  def initialize(x, y, width, height)
    super(x, y, width, height)
    self.z = 112
    reset_all
  end
#------------------------------------------------------------------------------#  
  def standard_padding
    return 6
  end
#------------------------------------------------------------------------------#  
  def reset_all
    @text_w = "Sintetizando..."
    self.height = 68
    @rand_number = -1
    @progress_b = 1
    refresh
  end
#------------------------------------------------------------------------------#  
  def set_percent(value)
    loop do
      @progress_b += value
      refresh
      Graphics.update
      break if @progress_b > self.width - 48
    end
  end
#------------------------------------------------------------------------------#  
  def random_make
    @rand_number = rand(100)
    Graphics.wait(24)
    self.height = 42
    if @rand_number <= Recipes_r[$index_rec][2]
      @text_w = "SUCESSO!"
      RPG::SE.new(Sound_Sucess_R[0], Sound_Sucess_R[1], Sound_Sucess_R[2]).play
    else
      @text_w = "FALHA!"
      RPG::SE.new(Sound_Error_R[0], Sound_Error_R[1], Sound_Error_R[2]).play
    end
  end
#------------------------------------------------------------------------------#  
  def return_result
    return @text_w == "SUCESSO!" ? true : false
  end
#------------------------------------------------------------------------------#  
  def refresh
    contents.clear
    random_make if @progress_b > self.width - 48
    draw_text(Rect.new(-3,0,self.width, 26),@text_w,1)
    if @progress_b <= self.width - 48
      draw_gauge(16, 20, @progress_b, 1, Color.new(88,173,100,244), Color.new(88,173,100,244))
    end
  end
end

#==============================================================================#
#-----|              Window - Lista de Itens Fabricáveis               |-------#
#==============================================================================#
class Window_ItemList_Crafter_Rose < Window_ItemList
#------------------------------------------------------------------------------#
  include Recipes_Rose
#------------------------------------------------------------------------------#
  def col_max
    return 1
  end
#------------------------------------------------------------------------------#
  def current_item_enabled?
    enable?(index)
  end
#------------------------------------------------------------------------------#
  def enable?(index)
    result = true
    data2 = []
      for i2 in 0..Recipes_r[index][0].length - 1
        data2[index] = $data_items[Recipes_r[index][0][i2][0]]
        quant = Recipes_r[index][0][i2][1]
        result = false if $game_party.item_number(data2[index]) < quant
      end
    return result
  end
#------------------------------------------------------------------------------#
  def make_item_list
    for i in 0..Recipes_r.length - 1
      @data[i] = $data_items[Recipes_r[i][1][0]]
    end
  end
#------------------------------------------------------------------------------#  
  def select_last
    select(0)
  end
#------------------------------------------------------------------------------#  
  def draw_item(index)
    item = @data[index]
    if item
      rect = item_rect(index)
      rect.width -= 4
      contents.font.size = 20
      draw_item_name(item, rect.x, rect.y, enable?(index))
    end
  end
end

#==============================================================================#
#-----|           Window - Lista de Ingredientes/Detalhes             |--------#
#==============================================================================#
class Window_Recipe_Rose < Window_Base
#------------------------------------------------------------------------------#
  include Recipes_Rose
#------------------------------------------------------------------------------#
  def initialize(x, y, width, height)
    super
    self.z = 100
    @data = []
    $index_rec = 0
    refresh
  end
#------------------------------------------------------------------------------#
  def standard_padding
    return 6
  end
#------------------------------------------------------------------------------#
  def enable?(i)
    result = true
    data2 = []
    data2[i] = $data_items[Recipes_r[$index_rec][0][i][0]]
    quant = Recipes_r[$index_rec][0][i][1]
    result = false if $game_party.item_number(data2[i]) < quant
    return result
  end
#------------------------------------------------------------------------------#
  def refresh
    contents.clear
    @data.clear
    contents.font.size = 20
    change_color(text_color(0))
    create_content_w
  end
#------------------------------------------------------------------------------#
  def create_content_w
    @item_descr = $data_items[Recipes_r[$index_rec][1][0]].description
    draw_text_f(8, 6, @item_descr)
    change_color(text_color(4))
    draw_text(Rect.new(-8,line_height*2.35,self.width,line_height),"- -- --- Materiais --- -- -",1)
      for i in 0..Recipes_r[$index_rec][0].length - 1
        @data[i] = $data_items[Recipes_r[$index_rec][0][i][0]]
        rect = item_rect(i)
        contents.font.size = 20
        draw_item_name(@data[i], rect.x, rect.y, enable?(i))
        contents.font.size = 18
        draw_item_number(rect, @data[i], i)
      end
    change_color(text_color(6))
    draw_text(Rect.new(16, self.height - 47,self.width,line_height),"Taxa de sucesso de fabricação: ",0)
    reset_font_settings
    Recipes_r[$index_rec][2] > 50 ? change_color(text_color(3)): change_color(text_color(2))
    draw_text(Rect.new(-38, self.height - 48,self.width,line_height), Recipes_r[$index_rec][2].to_s+"%",2)
  end
#------------------------------------------------------------------------------#
  def item_rect(i)
    rect = Rect.new
    rect.width = self.width - 18
    rect.height = 32
    rect.y = 76 + i * 23
    rect
  end
#------------------------------------------------------------------------------#
  def draw_item_number(rect, item, i)
    data3 = []
    data3[i] = Recipes_r[$index_rec][0][i][1]
    draw_text(rect, sprintf($game_party.item_number(item).to_s+" /%2d", data3[i]), 2)
  end
#------------------------------------------------------------------------------#
  def draw_text_f(x, y, text)
    text = convert_escape_characters(text)
    pos = {x: x, y: y, new_x: x, height: calc_line_height(text)}
    process_character(text.slice!(0, 1), text, pos) until text.empty?
  end
end

#==============================================================================#
#------------|            Scene - Centro de Criação                 |----------#
#==============================================================================#
class Scene_Crafter_Rose < Scene_ItemBase
#------------------------------------------------------------------------------#
  include Recipes_Rose
#------------------------------------------------------------------------------#
  def start
    super
    create_list_and_infos_items_rose
    @confirm_craft = Window_ConfirmCraft.new
    @confirm_craft.set_handler(:to_confirm, method(:create_item_rose))
    @confirm_craft.set_handler(:cancel, method(:on_confirm_cancel))
    deactivate_and_hide(@confirm_craft)
    @window_confirm_text = Window_Name_Rose.new(Graphics.width/2-184,@confirm_craft.y-40,368, 40, "Deseja fabricar o item escolhido?", 0)
    @window_confirm_text.hide
    @window_name1 = Window_Name_Rose.new(0,0,Graphics.width, 40, "Centro de Criação", 5)
    @window_name2 = Window_Name_Rose.new(0,@window_name1.y+40,Graphics.width/2.6, 40, "Item", 0)
    @window_name3 = Window_Name_Rose.new(@window_name2.width,@window_name1.y+40,Graphics.width-@window_name2.width, 40, "Informações", 0)
    @window_make_i = Window_Bar_Rose.new(Graphics.width/2-184,@confirm_craft.y-40,368, 68)
    deactivate_and_hide(@window_make_i)
    update
  end
#------------------------------------------------------------------------------#  
  def create_list_and_infos_items_rose
    @item_list_craft = Window_ItemList_Crafter_Rose.new(0,Graphics.height-336,Graphics.width/2.6, 336)
    @item_list_craft.category = :item
    @item_list_craft.set_handler(:ok,     method(:item_ok))
    @item_list_craft.set_handler(:cancel, method(:return_scene))
    @item_list_craft.select(0)
    @item_list_craft.activate
    @recipe_w = Window_Recipe_Rose.new(@item_list_craft.width,@item_list_craft.y,Graphics.width-@item_list_craft.width, @item_list_craft.height)
  end
#------------------------------------------------------------------------------#  
  alias update_newrose update
  def update
    update_newrose
    if @item_list_craft.index != $index_rec
      $index_rec = @item_list_craft.index
      @recipe_w.refresh
    end
  end
#------------------------------------------------------------------------------#  
  def deactivate_and_hide(window, bool = true)
    if bool
      window.deactivate
      window.hide
    else
      window.activate
      window.show
    end
  end
#------------------------------------------------------------------------------#  
  def item_ok
    @item_list_craft.deactivate
    Graphics.wait(24)
    deactivate_and_hide(@confirm_craft, false)
    @window_confirm_text.show
  end
#------------------------------------------------------------------------------#  
  def create_item_rose
    deactivate_and_hide(@confirm_craft)
    @window_confirm_text.hide
    Graphics.wait(24)
    deactivate_and_hide(@window_make_i, false)
    @window_make_i.reset_all
    @window_make_i.set_percent(2)
    Graphics.wait(74)
    change_items
    deactivate_and_hide(@window_make_i)
    @item_list_craft.activate
  end
#------------------------------------------------------------------------------#
  def change_items
    if @window_make_i.return_result
      $game_party.gain_item($data_items[Recipes_r[$index_rec][1][0]], Recipes_r[$index_rec][1][1])
    end
      for i in 0..Recipes_r[$index_rec][0].length - 1
        $game_party.gain_item($data_items[Recipes_r[$index_rec][0][i][0]], -Recipes_r[$index_rec][0][i][1])
      end
    @recipe_w.refresh
    @item_list_craft.refresh
  end
#------------------------------------------------------------------------------#
  def on_confirm_cancel
    deactivate_and_hide(@confirm_craft)
    @window_confirm_text.hide
    @item_list_craft.activate
  end
end
