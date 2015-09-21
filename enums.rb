#TODO refactor
# Class with all enums used at the project
# @author Marcus Vinicius de Carvalho <marcus.carvalho@aiesedc.net>
class Enums
  $enum_apps_name = {
    :app1 => '1. Inscritos',
    :app2 => '2. Abordagem',
    :app3 => '3. Dinâmica de grupo',
    :app4 => '4. Entrevista',
    :app5 => '5. Membros'
  }
  $enum_oGIP_apps_name = {
    :leads => '1. Inscritos',
    :contacteds => '2. Abordados',
    :epi => '3. EPI',
    :open => '4. Open',
    :ip => '5. In Progress',
    :ma => '6. Match',
    :re => '7. Realize'
  }
  $enum_type = { :ors => 1,
                 :national => 2,
                 :local => 3 }
  $enum_area = { :tm => 306775522,
                 :ogip => 306774653,
                 :ogcdp => 306774783,
                 :mkt => 306775660,
                 :fin => 306775701,
                 :igip => 306774699,
                 :igcdp => 306774749,
                 :bd => 306775405}
  $enum_robot = { :admin => 1,
                  :regular => 2,
                  :light => 3 }

  $enum_sexo = {:masculino => 1,
                :feminino => 2}
  $enum_operadora = {:claro => 1,
                     :tim => 2,
                     :oi => 3,
                     :vivo => 4,
                     :outra => 5}
  $enum_formacao = {:superior_incompleto => 1,
                    :superior_completo => 2,
                    :pos_graduacao_incompleta => 3,
                    :pos_graduacao_completa => 4,
                    :mestrado_doutorado => 5}
  $enum_semestre = {:s1 => 1,
                    :s2 => 2,
                    :s3 => 3,
                    :s4 => 4,
                    :s5 => 5,
                    :s6 => 6,
                    :s7 => 7,
                    :s8 => 8,
                    :s9 => 9,
                    :s10 => 10,
                    :concluido => 12,
                    :outro => 11}
  $enum_lingua = {:desconhecido => 4,
                  :basico => 1,
                  :intermediario => 2,
                  :avancado => 3}
  $enum_turno = {:manha => 1,
                 :tarde => 2,
                 :noite => 3}
  $enum_programa = {:jovenstalentos => 1,
                    :outro => 2}
  $enum_conheceu = {:desconhecido => 12,
                    :amigos_parentes => 1,
                    :cartazes => 2,
                    :saladeaula => 3,
                    :entidadeestudantil => 4,
                    :facebook_twitter => 5,
                    :eventos => 6,
                    :jornal_tv => 7,
                    :emailmarketingfolder => 80,
                    :flyer => 9,
                    :postal => 10}
  $enum_inscricao_especifica = {:sim => 1,
                                :nao => 2}
                                
  $enum_abordado = {:sim => 1,
                    :nao => 2}
  $enum_boolean = {:sim => 2,
                    :nao => 1}

  $enum_sex = {
    :masculino => 1,
    :feminino => 2
  }
  $enum_carrier = {
    :claro => 1,
    :tim => 2,
    :oi => 3,
    :vivo => 4,
    :outra => 5
  }
  $enum_english_level = {
    :desconhecido => 4,
    :basico => 1,
    :intermediario => 2,
    :avancado => 3
  }
  $enum_spanish_level = {
    :desconhecido => 4,
    :basico => 1,
    :intermediario => 2,
    :avancado => 3
  }
  $enum_study_stage = {
    :superior_incompleto => 1,
    :superior_completo => 2,
    :pos_graduacao_incompleta => 3,
    :pos_graduacao_completa => 4,
    :mestrado_doutorado => 5
  }
  $enum_best_moment = {
    :manha => 1,
    :tarde => 2,
    :noite => 3
  }
  $enum_semester = {
    :s1 => 1,
    :s2 => 2,
    :s3 => 3,
    :s4 => 4,
    :s5 => 5,
    :s6 => 6,
    :s7 => 7,
    :s8 => 8,
    :s9 => 9,
    :s10 => 10,
    :complete => 11,
    :other => 12,
  }
  $enum_priority = {
    :p1 => 1,
    :p2 => 2,
    :p3 => 3,
    :p4 => 4,
    :p5 => 5
  }
  $enum_marketing_channel ={
    :postal => 1,
    :friends => 2,
    :posters => 3,
    :class_room => 4,
    :junior_company => 5,
    :events => 6,
    :newspaper => 7,
    :mailing => 8,
    :flyer => 9,
    :facebook => 10,
    :global_village => 11,
    :other => 12
  }
  $enum_interest = {
    :managerment => 1,
    :teaching => 2,
    :marketing => 3,
    :engineering => 4,
    :startups => 5
  }
  $enum_abordado = {:nao => 1,
                    :sim => 2}

  $enum_foi_transferido_ors = {:sim => 1,
                               :nao => 2}

  $enum_dinamica_marcada = {:nao => 1,
                               :sim => 2}

  $enum_aprovado_dinamica = {:nao => 1,
                        :sim => 2}

  $enum_resultado_entrevista = {:nao_compareceu => 1,
                                :compareceu_nao_aprovado => 2,
                                :nao_aprovado => 2,
                                :aprovado => 3}
end