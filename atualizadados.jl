using DataFrames, CSV, Dates  
dateformat = DateFormat("yyyy-mm-dd")

# url_dataSC  = "ftp://boavista:dados_abertos@ftp2.ciasc.gov.br/boavista_covid_dados_abertos.csv"
# rawdata = CSV.read(download(url_dataSC),normalizenames=true,missingstrings=["NULL", "IGNORADO"], delim = ";")
rawdata = CSV.read("boavista_covid_dados_abertos.csv",normalizenames=true,missingstrings=["NULL", "IGNORADO"],delim = ";")
rawdata[!,:data_publicacao] = Date.(SubString.(rawdata.data_publicacao,1,10),dateformat)
rawdata[!,:data_resultado] = Date.(SubString.(rawdata.data_resultado,1,10),dateformat)
# rawdata[!,:data_coleta] = Date.(skipmissing(rawdata.data_coleta),dateformat)

# names(rawdata)
# [:data_publicacao, :recuperados, :data_inicio_sintomas, 
# :data_coleta, :sintomas, :comorbidades, :gestante, 
# :internacao, :internacao_uti, :sexo, :municipio, 
# :obito, :data_obito, :idade, :regional, :raca, 
# :data_resultado, :codigo_ibge_municipio, :latitude, 
# :longitude, :estado, :criterio_confirmacao, :tipo_teste, 
# municipio_notificacao, :codigoP_ibge_municipio_notificacao, 
# :latitude_notificacao, :longitude_notificacao, 
# :classificacao, :origem_esus, :origem_sivep, 
# :origem_lacen, :origem_laboratorio_privado, 
# :nom_laboratorio, :fez_teste_rapido, :fez_pcr, 
# :data_internacao, :data_entrada_uti, :regional_saude, 
# :data_evolucao_caso, :data_saida_uti, :bairro]


function geradf(rawdata::AbstractDataFrame, Estado::String = "SC")
    data_inicial = Date(2020,02,25)
    data_final = rawdata.data_publicacao[end]
    # Conta numero de casos
    df = DataFrame(regiao = "SC", estado = Estado, data=collect(data_inicial:Day(1):data_final))
    dfnumcasos = combine(nrow, groupby(rawdata,:data_inicio_sintomas , skipmissing = true,sort=true))
    rename!(dfnumcasos,[:data, :casos_novos])
    df = outerjoin(df, dfnumcasos, on = :data)
    df.casos_novos = coalesce.(df.casos_novos, 0)
    df.casos_acumulados = cumsum(df.casos_novos)
    # Conta numero de obitos
    dfnumobitos = combine(nrow,groupby(rawdata,:data_obito, skipmissing=true, sort=true))
    rename!(dfnumobitos,[:data, :obitos_novos])
    df = outerjoin(df, dfnumobitos, on = :data)
    df.obitos_novos = coalesce.(df.obitos_novos, 0)
    df.obitos_acumulados = cumsum(df.obitos_novos)
    return df
end

df = geradf(rawdata,"SC")

grrawdata = groupby(filter(row->row[:regional] .!= "OUTROS PAISES" && row[:regional] .!= "OUTROS ESTADOS",rawdata),:regional)

for df_raw in grrawdata
    append!(df,geradf(df_raw,df_raw[1,:regional]))
end

dados_pop = DataFrame(regiao =["ALTO VALE DO ITAJAI","FOZ DO RIO ITAJAI","GRANDE FLORIANOPOLIS","GRANDE OESTE","MEIO OESTE E SERRA CATARINENSE","PLANALTO NORTE E NORDESTE","SC","SUL"], 
    sigla_regiao = ["AVI","FVI","GFL","GOE","MOS","PNN","SC","SUL"], populacao =  [1077659,698912,1189947,792895,916252,1400128,7252502,999701])

for row in eachrow(dados_pop)
    replace!(df.estado,row[:regiao]=>row[:sigla_regiao])
    # println(row[:regiao],";",row[:sigla_regiao],";",row[:populacao])
end


CSV.write("../covid19model/Brazil/data/sc-deaths.csv",df)



