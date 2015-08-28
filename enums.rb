#TODO refactor
# Class with all enums used at the project
# @author Marcus Vinicius de Carvalho <marcus.carvalho@aiesedc.net>
class Enums
  $enum_apps_name = {
    :app1 => '1. Inscritos',
    :app2 => '2. Abordagem',
    :app3 => '3. Dinâmica de grupo',
    :app4 => '4. Entrevista',
    :app5 => '5. Membros',
    :ogip => 'Pessoas'
  }
  $enum_type = { :ors => 1,
                 :national => 2,
                 :local => 3 }
  $enum_area = { :tm => 306775522,
                 :ogip => 30677463,
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
    :completo => 11,
    :outro => 12,
  }
  $enum_moment = {

  }
  $enum_priority = {
    
  }
  $enum_marketing_channel ={

  }
  $enum_interest = {

  }
  $enum_abordado = {:nao => 1,
                    :sim => 2}

  $enum_foi_transferido_ors = {:sim => 1,
                               :nao => 2}

  $enum_compareceu_dinamica = {:nao => 1,
                               :sim => 2}

  $enum_entrevistado = {:nao => 1,
                        :sim => 2}

  $enum_virou_membro = {:nao => 1,
                        :sim => 2}
end