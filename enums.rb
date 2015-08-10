class Enums
  $enum_apps_name = {:app1 => '1. Inscritos',
                     :app2 => '2. Abordagem',
                     :app3 => '3. Dinâmica de grupo',
                     :app4 => '4. Entrevista',
                     :app5 => '5. Membros'}
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
                    :concluido => 11,
                    :outro => 12}
  $enum_lingua = {:desconhecido => 1,
                  :basico => 2,
                  :intermediario => 2,
                  :avancado => 3}
  $enum_turno = {:manha => 1,
                 :tarde => 2,
                 :noite => 3}
  $enum_programa = {:jovenstalentos => 1,
                    :outro => 2}
  $enum_conheceu = {:desconhecido => 1,
                    :amigos_parentes => 2,
                    :cartazes => 3,
                    :saladeaula => 4,
                    :entidadeestudantil => 5,
                    :facebook_twitter => 6,
                    :eventos => 7,
                    :jornal_tv => 8,
                    :emailmarketingfolder => 9,
                    :flyer => 10,
                    :postal => 11}
  $enum_inscricao_especifica = {:sim => 1,
                                :nao => 2}
  $enum_abordado = {:sim => 1,
                    :nao => 2}
end