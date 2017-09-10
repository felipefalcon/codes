#==============================================================================
# Módulo da Title
#------------------------------------------------------------------------------
# Configurações das imagens da Title na Tela
#==============================================================================

module Configs_Title
  
  LOGO_IMG = "Logo"
  LOGO_X = 640/2 - 200
  LOGO_Y = 56
  
  # Linha 1: Altera o Y (Novo Jogo, Continue, Como jogar)
  # Linha 2: Altera o Y (Opções, Sair)
  OPS_LINE1_Y = 480 - 130
  OPS_LINE2_Y = 480 - 85
  
  OP1_IMG = "NewGame"
  OP1_X = 640/2 - 220
  
  OP2_IMG = "Continue"
  OP2_X = 640/2 - 65
  
  OP3_IMG = "HowToPlay"
  OP3_X = 640/2 + 90
  
  OP4_IMG = "Options"
  OP4_X = 640/2 - 140
  
  OP5_IMG = "ExitGame"
  OP5_X = 640/2 + 10
  
  # As imagens deve estar na pasta Title
  # Pode adicionar quantas quiser pro "Como Jogar"
  COMOJ_IMGS = ["ComoJogar1", "ComoJogar2", "ComoJogar3", "ComoJogar1" ]
  
end

#==============================================================================
# Scene_Title
#------------------------------------------------------------------------------
# Esta classe trata da Tela de Título
#==============================================================================

class Scene_Title
  
  #--------------------------------------------------------------------------
  # Processamento Principal
  #--------------------------------------------------------------------------
  def main
    # Se estiver em Teste de Batalha
    if $BTEST
      battle_test
      return
    end
    # Carregar o Banco de Dados
    $data_actors        = load_data("Data/Actors.rxdata")
    $data_classes       = load_data("Data/Classes.rxdata")
    $data_skills        = load_data("Data/Skills.rxdata")
    $data_items         = load_data("Data/Items.rxdata")
    $data_weapons       = load_data("Data/Weapons.rxdata")
    $data_armors        = load_data("Data/Armors.rxdata")
    $data_enemies       = load_data("Data/Enemies.rxdata")
    $data_troops        = load_data("Data/Troops.rxdata")
    $data_states        = load_data("Data/States.rxdata")
    $data_animations    = load_data("Data/Animations.rxdata")
    $data_tilesets      = load_data("Data/Tilesets.rxdata")
    $data_common_events = load_data("Data/CommonEvents.rxdata")
    $data_system        = load_data("Data/System.rxdata")
    # Criar um Sistema
    $game_system = Game_System.new
    # Variáveis usadas na Title
    @cursor_ops = 0
    @cursor_ops_old_value = 0
    @not_change_opacity = false
    # Criação da imagem de fundo do título
    @sprite = Plane.new
    @sprite.bitmap = RPG::Cache.title($data_system.title_name)
    # Criação da imagem da Logo e posicionamento
    @sprite_logo = Sprite.new
    @sprite_logo.bitmap = RPG::Cache.title(Configs_Title::LOGO_IMG)
    @sprite_logo.x = Configs_Title::LOGO_X
    @sprite_logo.y = Configs_Title::LOGO_Y
    # Criação das sprites das imagens de opções
    for i in 1..7
      instance_variable_set("@sprite_op" + i.to_s, Sprite.new)
    end
    # Definição das imagens e posições
    @sprite_op1.bitmap = RPG::Cache.title(Configs_Title::OP1_IMG)
    @sprite_op1.x = Configs_Title::OP1_X
    @sprite_op2.bitmap = RPG::Cache.title(Configs_Title::OP2_IMG)
    @sprite_op2.x = Configs_Title::OP2_X
    @sprite_op3.bitmap = RPG::Cache.title(Configs_Title::OP3_IMG)
    @sprite_op3.x = Configs_Title::OP3_X
    @sprite_op4.bitmap = RPG::Cache.title(Configs_Title::OP4_IMG)
    @sprite_op4.x = Configs_Title::OP4_X
    @sprite_op5.bitmap = RPG::Cache.title(Configs_Title::OP5_IMG)
    @sprite_op5.x = Configs_Title::OP5_X
    @sprite_op1.y = @sprite_op2.y = @sprite_op3.y = Configs_Title::OPS_LINE1_Y
    @sprite_op4.y = @sprite_op5.y = Configs_Title::OPS_LINE2_Y
    @sprite_op6.bitmap = RPG::Cache.title(Configs_Title::COMOJ_IMGS[0])
    @sprite_op7.bitmap = RPG::Cache.title(Configs_Title::COMOJ_IMGS[0])
    # Definição das opacidades iniciais das imagens
    @sprite_op1.opacity = @sprite_op2.opacity = @sprite_op3.opacity = @sprite_op4.opacity = @sprite_op5.opacity = 90
    @sprite_op6.opacity = 0
    @sprite_op7.opacity = 0
    # Aqui é checado se existe algum arquivo de save
    # Se estiver habilitado, tornar @continue_enabled verdadeiro; se estiver 
    # desabilitado, tornar falso
    @continue_enabled = false
    for i in 0..3
      if FileTest.exist?("Save#{i+1}.rxdata")
        @continue_enabled = true
        @cursor_ops = 1
        @cursor_ops_old_value = 1
      end
    end
    # Reproduzir BGM de Título
    $game_system.bgm_play($data_system.title_bgm)
    # Parar de reproduzir BGS e ME
    Audio.me_stop
    Audio.bgs_stop
    # Executar transição
    # Loop principal
    Graphics.transition
    loop do
    # Atualizar a tela de jogo
      Graphics.update
    # Atualizar a entrada de informações
      Input.update
    # Atualizar o frame
      update
    # Abortar o loop caso a tela tenha sido alterada
      if $scene != self
        break
      end
    end
    # Preparar para transição
    Graphics.freeze
    # Exibir a janela de comandos
    # Limpeza das imagens
    @sprite.bitmap.dispose
    @sprite.dispose
    @sprite_logo.bitmap.dispose
    @sprite_logo.dispose
    @sprite_op1.bitmap.dispose
    @sprite_op1.dispose
    @sprite_op2.bitmap.dispose
    @sprite_op2.dispose
    @sprite_op3.bitmap.dispose
    @sprite_op3.dispose
    @sprite_op4.bitmap.dispose
    @sprite_op4.dispose
    @sprite_op5.bitmap.dispose
    @sprite_op5.dispose
    @sprite_op6.bitmap.dispose
    @sprite_op6.dispose
    @sprite_op7.bitmap.dispose
    @sprite_op7.dispose
  end
  
  #--------------------------------------------------------------------------
  # Atualização do Frame
  #--------------------------------------------------------------------------
  
  def update
  # Movimento do fundo
    @sprite.ox -= 1
  # Verificação do pressionar Space/Enter
    if Input.trigger?(Input::C)
      case @cursor_ops
        when 0; command_new_game
        when 1; command_continue
        when 2; command_howtoplay
        when 3; command_options_c
        when 4; command_shutdown
      end
    end
  # Verificação do pressionar das Direcionais
    if Input.trigger?(Input::RIGHT) && @cursor_ops < 4
       @cursor_ops += 1
       @not_change_opacity = false
    end
    if Input.trigger?(Input::LEFT) && @cursor_ops > 0
       @cursor_ops -= 1
       @not_change_opacity = false
    end
    if Input.trigger?(Input::DOWN) && @cursor_ops <= 2
       if @cursor_ops == 2
         @cursor_ops += 2  
       else
         @cursor_ops += 3
       end
       @not_change_opacity = false
    end
    if Input.trigger?(Input::UP) && @cursor_ops > 2
       @cursor_ops -= 3
       @not_change_opacity = false
    end
  # Verificador de mover o cursor: tocar SE
    if @cursor_ops != @cursor_ops_old_value
       $game_system.se_play($data_system.cursor_se)
       @cursor_ops_old_value = @cursor_ops
    end
  # Efeito de opacidade se o cursor mudar
    options_opacity if @not_change_opacity == false
  end
  
  #--------------------------------------------------------------------------
  # Método de efeito de opacidade
  #--------------------------------------------------------------------------
  
  def options_opacity
  # Se o continuar não estiver ativo: trocar cor
    @sprite_op2.color.set(0,0,100,100) if @continue_enabled == false
  # Opacidades de todas as opções Aumentar (Ficar Invísivel)  
    @sprite_op1.opacity -= 12 if @sprite_op1.opacity > 90
    @sprite_op2.opacity -= 12 if @sprite_op2.opacity > 90
    @sprite_op3.opacity -= 12 if @sprite_op3.opacity > 90
    @sprite_op4.opacity -= 12 if @sprite_op4.opacity > 90
    @sprite_op5.opacity -= 12 if @sprite_op5.opacity > 90
  # Opacidade da opção que estiver ativa
    if @cursor_ops == 0
      @sprite_op1.opacity += 24 if @sprite_op1.opacity < 255
      @not_change_opacity = true if @sprite_op1.opacity >= 255
    end
    if @cursor_ops == 1
      @sprite_op2.opacity += 24 if @sprite_op2.opacity < 255
      @not_change_opacity = true if @sprite_op2.opacity >= 255
    end
    if @cursor_ops == 2
      @sprite_op3.opacity += 24 if @sprite_op3.opacity < 255
      @not_change_opacity = true if @sprite_op3.opacity >= 255
    end
    if @cursor_ops == 3
      @sprite_op4.opacity += 24 if @sprite_op4.opacity < 255
      @not_change_opacity = true if @sprite_op4.opacity >= 255
    end
    if @cursor_ops == 4
      @sprite_op5.opacity += 24 if @sprite_op5.opacity < 255
      @not_change_opacity = true if @sprite_op5.opacity >= 255
    end
  end
  
  #--------------------------------------------------------------------------
  # Comando: Novo Jogo
  #--------------------------------------------------------------------------
  
  def command_new_game
    # Reproduzir SE de OK
    $game_system.se_play($data_system.decision_se)
    # Parar BGM
    Audio.bgm_stop
    # Aqui o contador de frames é resetado para que se conte o Tempo de Jogo
    Graphics.frame_count = 0
    # Criar cada tipo de objetos do jogo
    $game_temp          = Game_Temp.new
    $game_system        = Game_System.new
    $game_switches      = Game_Switches.new
    $game_variables     = Game_Variables.new
    $game_self_switches = Game_SelfSwitches.new
    $game_screen        = Game_Screen.new
    $game_actors        = Game_Actors.new
    $game_party         = Game_Party.new
    $game_troop         = Game_Troop.new
    $game_map           = Game_Map.new
    $game_player        = Game_Player.new
    # Configurar Grupo Inicial
    $game_party.setup_starting_members
    # Configurar posição inicial no mapa
    $game_map.setup($data_system.start_map_id)
    # Aqui o Jogador é movido até a posição inical configurada
    $game_player.moveto($data_system.start_x, $data_system.start_y)
    # Atualizar Jogador
    $game_player.refresh
    # Rodar, de acordo com o mapa, a BGM e a BGS
    $game_map.autoplay
    # Atualizar mapa (executar processos paralelos)
    $game_map.update
    # Mudar para a tela do mapa
    $scene = Scene_Map.new
  end
  
  #--------------------------------------------------------------------------
  # Comando: Continuar
  #--------------------------------------------------------------------------
  
  def command_continue
    # Se Continuar estiver desabilitado
    unless @continue_enabled
      # Reproduzir SE de erro
      $game_system.se_play($data_system.buzzer_se)
      return
    end
    # Reproduzir SE de OK
    $game_system.se_play($data_system.decision_se)
    # Mudar para a tela de Carregar arquivos
    $scene = Scene_Load.new
  end
  
  #--------------------------------------------------------------------------
  # Comando: Como Jogar
  #--------------------------------------------------------------------------
  
  def command_howtoplay
    imgs_comoj = Configs_Title::COMOJ_IMGS.length
    img_s = 0
    count = 0
    @sprite_op1.opacity = @sprite_op2.opacity = @sprite_op3.opacity = @sprite_op4.opacity = @sprite_op5.opacity = 0
     loop do
       @sprite.ox -= 1
       count += 1
       if img_s == imgs_comoj
       @sprite_op6.opacity -= 8
       @sprite_op7.opacity -= 8
       else
       @sprite_op6.opacity += 8 if img_s % 2 == 0
       @sprite_op6.opacity -= 8 if img_s % 2 == 1
       @sprite_op7.opacity += 8 if img_s % 2 == 1
       @sprite_op7.opacity -= 8 if img_s % 2 == 0
       if img_s % 2 == 0
       @sprite_op6.bitmap = RPG::Cache.title(Configs_Title::COMOJ_IMGS[img_s])
       else
       @sprite_op7.bitmap = RPG::Cache.title(Configs_Title::COMOJ_IMGS[img_s])
       end
       end
       Graphics.update
       Input.update
       if Input.trigger?(Input::C) && img_s < imgs_comoj && count > 50
       img_s += 1
       count = 0
       end
       break if img_s == imgs_comoj && @sprite_op6.opacity == 0 && @sprite_op7.opacity == 0
     end
     @sprite_op1.opacity = @sprite_op2.opacity = @sprite_op4.opacity = @sprite_op5.opacity = 90
     @sprite_op3.opacity = 255
  end
  
  #--------------------------------------------------------------------------
  # Comando: Opções
  #--------------------------------------------------------------------------
  
  def command_options_c
    
  end
  
  #--------------------------------------------------------------------------
  # Comando: Sair
  #--------------------------------------------------------------------------
  
  def command_shutdown
    # Reproduzir SE de OK
    $game_system.se_play($data_system.decision_se)
    # Diminuir o volume de BGM, BGS e ME
    Audio.bgm_fade(800)
    Audio.bgs_fade(800)
    Audio.me_fade(800)
    # Sair
    $scene = nil
  end
  
  #--------------------------------------------------------------------------
  # Teste de Batalha
  #--------------------------------------------------------------------------
  
  def battle_test
    # Carregar Banco de Dados para o Teste de Batalha
    $data_actors        = load_data("Data/BT_Actors.rxdata")
    $data_classes       = load_data("Data/BT_Classes.rxdata")
    $data_skills        = load_data("Data/BT_Skills.rxdata")
    $data_items         = load_data("Data/BT_Items.rxdata")
    $data_weapons       = load_data("Data/BT_Weapons.rxdata")
    $data_armors        = load_data("Data/BT_Armors.rxdata")
    $data_enemies       = load_data("Data/BT_Enemies.rxdata")
    $data_troops        = load_data("Data/BT_Troops.rxdata")
    $data_states        = load_data("Data/BT_States.rxdata")
    $data_animations    = load_data("Data/BT_Animations.rxdata")
    $data_tilesets      = load_data("Data/BT_Tilesets.rxdata")
    $data_common_events = load_data("Data/BT_CommonEvents.rxdata")
    $data_system        = load_data("Data/BT_System.rxdata")
    # Aqui o contador de frames é resetado para que se conte o Tempo de Jogo
    Graphics.frame_count = 0
    # Criar cada tipo de objetos do jogo
    $game_temp          = Game_Temp.new
    $game_system        = Game_System.new
    $game_switches      = Game_Switches.new
    $game_variables     = Game_Variables.new
    $game_self_switches = Game_SelfSwitches.new
    $game_screen        = Game_Screen.new
    $game_actors        = Game_Actors.new
    $game_party         = Game_Party.new
    $game_troop         = Game_Troop.new
    $game_map           = Game_Map.new
    $game_player        = Game_Player.new
    # Configurar Grupo para o Teste de Batalha
    $game_party.setup_battle_test_members
    # Definir o ID do Grupo de Inimigos, a possibilidade de fuga e o Fundo de 
    # Batalha
    $game_temp.battle_troop_id = $data_system.test_troop_id
    $game_temp.battle_can_escape = true
    $game_map.battleback_name = $data_system.battleback_name
    # Reproduzri SE de início de batalha
    $game_system.se_play($data_system.battle_start_se)
    # Reproduzir BGM de batalha
    $game_system.bgm_play($game_system.battle_bgm)
    # Mudar para a tela de batalha
    $scene = Scene_Battle.new
  end
end
