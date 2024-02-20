require 'roo'
class XlsxtopgController < ApplicationController
  before_action :authenticate_user!, only: %i[index ]
  before_action :require_admin, only: [:index, :preluaredate, :preluaredate1, :preluaredate2, :preluaredate3, :preluaredate4,
    :preluaredate5, :preluaredate6, :preluaredate7, :preluaredate8, :preluaredate9, :preluaredate10, :preluaredate11, :preluaredate12,
    :preluaredate13, :preluaredate14, :preluaredate15, :preluaredate16, :preluaredate17, :preluaredate18, :preluaredate19,
     :preluaredate20, :preluaredate21, :preluaredate22, :preluaredate23,
    :sterge_inregistrari, :sterge_inregistrari1, :sterge_inregistrari2,
    :sterge_inregistrari3, :sterge_inregistrari4, :sterge_inregistrari5, :sterge_inregistrari6, :sterge_inregistrari7, :sterge_inregistrari8,
    :sterge_inregistrari10]
  def index
  end
  def preluaredate # Preluare date din toate tabelele
    @verificare_apelare = true
    preluaredate1()
    preluaredate2()
    preluaredate3()  
    preluaredate4()
    preluaredate5()
    preluaredate6()
    preluaredate7()
    redirect_to xlsxtopg_index_path, notice: 'Datele au fost preluate cu succes!'
  end
  def preluaredate1 #Plante
    if Rails.env.production?
      xlsx = Roo::Spreadsheet.open('/opt/render/project/src/app/fisierele/Plante.xlsx')
    else  
      xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'plante.xlsx'))
    end  
    cap_tabel = xlsx.sheet(0).row(1).map { |col| col.to_s.downcase } # array cu fieldurile din prima linie a fisierului xlsx
  
    xlsx.each_row_streaming(offset: 1,pad_cells: true) do |row|
      # verificam daca numele exista deja in baza de date
      next if Plante.exists?(nume: row[cap_tabel.index('nume')]&.value) if cap_tabel.include?('nume')
      idp_index = cap_tabel.index('idp')
      idp = idp_index ? row[idp_index]&.value : nil

      tip_index = cap_tabel.index('tip')
      tip = tip_index ? row[tip_index]&.value : nil
      
      subt_index = cap_tabel.index('subt')
      subt = subt_index ? row[subt_index]&.value : nil
      
      nume_index = cap_tabel.index('nume')
      nume = nume_index ? row[nume_index]&.value : nil
      
      numeayu_index = cap_tabel.index('numeayu')
      numeayu = numeayu_index ? row[numeayu_index]&.value : nil
      
      numesec_index = cap_tabel.index('numesec')
      numesec = numesec_index ? row[numesec_index]&.value : nil
      
      numesec2_index = cap_tabel.index('numesec2')
      numesec2 = numesec2_index ? row[numesec2_index]&.value : nil
      
      denbot_index = cap_tabel.index('denbot')
      denbot = denbot_index ? row[denbot_index]&.value : nil
      
      fam_index = cap_tabel.index('fam')
      fam = fam_index ? row[fam_index]&.value : nil

      plante = Plante.new(idp: idp,tip: tip,subt: subt,nume: nume,numeayu: numeayu,numesec: numesec,
        numesec2: numesec2,denbot: denbot,fam: fam)
     plante.save
     #xlsx.close
    end
    if !defined?(@verificare_apelare) || (@verificare_apelare.nil? && !caller.find { |c| c.include?("preluaredate") })
      redirect_to xlsxtopg_index_path, notice: 'Datele au fost preluate cu succes!'
    end  
  end
  def preluaredate2
    if Rails.env.production?
      xlsx1 = Roo::Spreadsheet.open('/opt/render/project/src/app/fisierele/Plante-parti.xlsx')
    else 
      xlsx1 = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'plante-parti.xlsx'))
    end  
    cap_tabel = xlsx1.sheet(0).row(1).map { |col| col.to_s.downcase } # array cu fieldurile din prima linie a fisierului xlsx
    cap_tabel.each_index do |i|
      if cap_tabel[i] == 'id'
        cap_tabel[i] = 'idx'
      elsif cap_tabel[i] == 'text sursa'
        cap_tabel[i] = 'textsursa'
      end
      if cap_tabel[i] == 'healthrel rom'
        cap_tabel[i] = 'healthrelrom'
      end  
    end
    #pana aici am pregatit arrayul @cap_tabel
    xlsx1.each_row_streaming(offset: 1, pad_cells: true) do |row|
      next if PlanteParti.exists?(idx: row[cap_tabel.index('idx')]&.value) if cap_tabel.include?('idx')     
      idx_index = cap_tabel.index('idx')
      idx = idx_index ? row[idx_index]&.value : nil
    
      cpl_index = cap_tabel.index('cpl')
      cpl = cpl_index ? row[cpl_index]&.value : nil
    
      parte_index = cap_tabel.index('parte')
      parte = parte_index ? row[parte_index]&.value : nil
    
      part_index = cap_tabel.index('part')
      part = part_index ? row[part_index]&.value : nil
    
      clasa_index = cap_tabel.index('clasa')
      clasa = clasa_index ? row[clasa_index]&.value : nil
    
      invpp_index = cap_tabel.index('invpp')
      invpp = invpp_index ? row[invpp_index]&.value : nil
    
      tippp_index = cap_tabel.index('tippp')
      tippp = tippp_index ? row[tippp_index]&.value : nil
    
      recomandari_index = cap_tabel.index('recomandari')
      recomandari = recomandari_index ? row[recomandari_index]&.value : nil
    
      textsursa_index = cap_tabel.index('textsursa')
      textsursa = textsursa_index ? row[textsursa_index]&.value : nil
    
      starereprez_index = cap_tabel.index('starereprez')
      starereprez = starereprez_index ? row[starereprez_index]&.value : nil
    
      z_index = cap_tabel.index('z')
      z = z_index ? row[z_index]&.value : nil
    
      healthrel_index = cap_tabel.index('healthrel')
      healthrel = healthrel_index ? row[healthrel_index]&.value : nil
    
      compozitie_index = cap_tabel.index('compozitie')
      compozitie = compozitie_index ? row[compozitie_index]&.value : nil
    
      etich_index = cap_tabel.index('etich')
      etich = etich_index ? row[etich_index]&.value : nil
    
      healthrelrom_index = cap_tabel.index('healthrelrom')
      healthrelrom = healthrelrom_index ? row[healthrelrom_index]&.value : nil
    
      propspeciale_index = cap_tabel.index('propspeciale')
      propspeciale = propspeciale_index ? row[propspeciale_index]&.value : nil
    
      selectie_index = cap_tabel.index('selectie')
      selectie = selectie_index ? row[selectie_index]&.value : nil
    
      lucru_index = cap_tabel.index('lucru')
      lucru = lucru_index ? row[lucru_index]&.value : nil
    
      s_index = cap_tabel.index('s')
      s = s_index ? row[s_index]&.value : nil
    
      sel_index = cap_tabel.index('sel')
      sel = sel_index ? row[sel_index]&.value : nil

      index2_index = cap_tabel.index('index2')
      index2 = index2_index ? row[index2_index]&.value : nil

      ordvol_index = cap_tabel.index('ordvol')
      ordvol = ordvol_index ? row[ordvol_index]&.value : nil

      selpz_index = cap_tabel.index('selpz')
      selpz = selpz_index ? row[selpz_index]&.value : nil

      selpzn_index = cap_tabel.index('selpzn')
      selpzn = selpzn_index ? row[selpzn_index]&.value : nil

      sels_index = cap_tabel.index('sels')
      sels = sels_index ? row[sels_index]&.value : nil

      selz_index = cap_tabel.index('selz')
      selz = selz_index ? row[selz_index]&.value : nil

      selnr_index = cap_tabel.index('selnr')
      selnr = selnr_index ? row[selnr_index]&.value : nil

      t10_index = cap_tabel.index('t10')
      t10 = t10_index ? row[t10_index]&.value : nil

      t11_index = cap_tabel.index('t11')
      t11 = t11_index ? row[t11_index]&.value : nil

      t12_index = cap_tabel.index('t12')
      t12 = t12_index ? row[t12_index]&.value : nil

      t13_index = cap_tabel.index('t13')
      t13 = t13_index ? row[t13_index]&.value : nil

      t14_index = cap_tabel.index('t14')
      t14 = t14_index ? row[t14_index]&.value : nil

      t15_index = cap_tabel.index('t15')
      t15 = t15_index ? row[t15_index]&.value : nil

      t16_index = cap_tabel.index('t16')
      t16 = t16_index ? row[t16_index]&.value : nil

      b_index = cap_tabel.index('b')
      b = b_index ? row[b_index]&.value : nil

      r_index = cap_tabel.index('r')
      r = r_index ? row[r_index]&.value : nil

      c_index = cap_tabel.index('c')
      c = c_index ? row[c_index]&.value : nil

      imp_index = cap_tabel.index('imp')
      imp = imp_index ? row[imp_index]&.value : nil

      testat_index = cap_tabel.index('testat')
      testat = testat_index ? row[testat_index]&.value : nil

      g1_index = cap_tabel.index('g1')
      g1 = g1_index ? row[g1_index]&.value : nil

      g2_index = cap_tabel.index('g2')
      g2 = g2_index ? row[g2_index]&.value : nil


      g3_index = cap_tabel.index('g3')
      g3 = g3_index ? row[g3_index]&.value : nil

      g4_index = cap_tabel.index('g4')
      g4 = g4_index ? row[g4_index]&.value : nil

      g5_index = cap_tabel.index('g5')
      g5 = g5_index ? row[g5_index]&.value : nil


      g6_index = cap_tabel.index('g6')
      g6 = g6_index ? row[g6_index]&.value : nil

      vir_index = cap_tabel.index('vir')
      vir = vir_index ? row[vir_index]&.value : nil

      vip_index = cap_tabel.index('vip')
      vip = vip_index ? row[vip_index]&.value : nil


      imaginepp_index = cap_tabel.index('imaginepp')
      imaginepp = imaginepp_index ? row[imaginepp_index]&.value : nil

      plante_parti = PlanteParti.new(idx: idx,cpl: cpl,parte: parte,part: part,clasa: clasa,invpp: invpp,tippp: tippp,
        recomandari: recomandari,textsursa: textsursa,starereprez: starereprez,z: z,healthrel: healthrel,compozitie: compozitie,
        etich: etich,healthrelrom: healthrelrom,propspeciale: propspeciale,selectie: selectie,lucru: lucru,s: s,sel: sel,index2: index2,
        ordvol: ordvol,selpz: selpz,selpzn: selpzn,sels: sels,selz: selz,selnr: selnr,t10: t10,t11: t11,t12: t12,t13: t13,t14: t14,
        t15: t15,t16: t16,b: b,r: r,c: c,imp: imp,testat: testat,g1:g1,g2: g2,g3: g3,g4: g4,g5: g5,g6: g6,vir: vir,vip: vip,
        imaginepp: imaginepp)
     plante_parti.save
    end
    if !defined?(@verificare_apelare) || (@verificare_apelare.nil? && !caller.find { |c| c.include?("preluaredate") })
      redirect_to xlsxtopg_index_path, notice: 'Datele au fost preluate cu succes!'
    end  
    
  end

  def preluaredate3
    if Rails.env.production?
      xlsx = Roo::Spreadsheet.open('/opt/render/project/src/app/fisierele/Recomandari.xlsx')
    else 
      xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'recomandari.xlsx'))
    end
    cap_tabel = xlsx.sheet(0).row(1).map { |col| col.to_s.downcase } # array cu fieldurile din prima linie a fisierului xlsx
    #cap_tabel.unshift("Listaproprietati_id".downcase)
    @arr=[]
    @cap_tabel=cap_tabel
    i=0
    xlsx.each_row_streaming(offset: 1, pad_cells: true) do |row|
      # verificam daca IDPP exista deja in baza de date
      next if Recomandari.exists?(idpr: row[cap_tabel.index('idpr')]&.value) if cap_tabel.include?('idpr')
      
      #listaproprietati_id_index = cap_tabel.index('listaproprietati_id')
      #listaproprietati_id = listaproprietati_id_index ? row[listaproprietati_id_index]&.value : nil
      #@arr.push(listaproprietati_id)
      idpr_index = cap_tabel.index('idpr')
      idpr = idpr_index ? row[idpr_index]&.value : nil
      #@arr.push(idpr)
      idp_index = cap_tabel.index('idp')
      idp = idp_index ? row[idp_index]&.value : nil
      #@arr.push(idp)
      idpp_index = cap_tabel.index('idpp')
      idpp = idpp_index ? row[idpp_index]&.value : nil
      #@arr.push(idpp)
      imp_index = cap_tabel.index('imp')
      imp = imp_index ? row[imp_index]&.value : nil
      #@arr.push(imp)
      tipp_index = cap_tabel.index('tipp')
      tipp = tipp_index ? row[tipp_index]&.value : nil
      #@arr.push(tipp)
      srota_index = cap_tabel.index('srota')
      srota = srota_index ? row[srota_index]&.value : nil
      #@arr.push(srota)
      proprietate_index = cap_tabel.index('proprietate')
      proprietate = proprietate_index ? row[proprietate_index]&.value : nil
      #@arr.push(proprietate)
      propeng_index = cap_tabel.index('propeng')
      propeng = propeng_index ? row[propeng_index]&.value : nil
      #@arr.push(propeng)
      propayur_index = cap_tabel.index('propayur')
      propayur = propayur_index ? row[propayur_index]&.value : nil
      #@arr.push(propayur)
      propgerm_index = cap_tabel.index('propgerm')
      propgerm = propgerm_index ? row[propgerm_index]&.value : nil
      #@arr.push(propgerm)
      completari_index = cap_tabel.index('completari')
      completari = completari_index ? row[completari_index]&.value : nil
      #@arr.push(completari)
      sursa_index = cap_tabel.index('sursa')
      sursa = sursa_index ? row[sursa_index]&.value : nil
      #@arr.push(sursa)
      sel_index = cap_tabel.index('sel')
      sel = sel_index ? row[sel_index]&.value : nil
      #@arr.push(sel)

      
      #recomandari = Recomandari.new(listaproprietati_id: listaproprietati_id, idpr: idpr, idp: idp, idpp: idpp, imp: imp, tipp: tipp, srota: srota, proprietate: proprietate, propeng: propeng, propayur: propayur, propgerm: propgerm, completari: completari, sursa: sursa, sel: sel)
      
      recomandari = Recomandari.new(idpr: idpr, idp: idp, idpp: idpp, imp: imp, tipp: tipp, srota: srota, proprietate: proprietate, propeng: propeng, propayur: propayur, propgerm: propgerm, completari: completari, sursa: sursa, sel: sel)
      recomandari.save
      #if i>5
        #break
      #end  
      #i=i+1
    end
    
    if !defined?(@verificare_apelare) || (@verificare_apelare.nil? && !caller.find { |c| c.include?("preluaredate") })
      redirect_to xlsxtopg_index_path, notice: 'Datele au fost preluate cu succes!'
    end  
  end  
    
  def preluaredate4 # Lista_proprietati
    if Recomandari.count>0
      if Rails.env.production?
        xlsx = Roo::Spreadsheet.open('/opt/render/project/src/app/fisierele/Lista_proprietati.xlsx')
      else 
        xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'Lista_proprietati.xlsx'))
      end  
    cap_tabel = xlsx.sheet(0).row(1).map { |col| col.to_s.downcase } # array cu fieldurile din prima linie a fisierului xlsx
     @cap_tabel=cap_tabel
    
    xlsx.each_row_streaming(offset: 1,pad_cells: true) do |row|
      # verificam daca id-ul exista deja in baza de date
      next if Listaproprietati.exists?(idx: row[cap_tabel.index('id')]&.value) if cap_tabel.include?('id')
      id_index = cap_tabel.index('id')
      idx = id_index ? row[id_index]&.value : nil 

      proprietateter_index = cap_tabel.index('proprietateter')
      proprietateter = proprietateter_index ? row[proprietateter_index]&.value : nil
  
      tipp_index = cap_tabel.index('tipp')
      tipp = tipp_index ? row[tipp_index]&.value : nil 
      
      srota_index = cap_tabel.index('srota')
      srota = srota_index ? row[srota_index]&.value : nil
      
      definire_index = cap_tabel.index('definire')
      definire = definire_index ? row[definire_index]&.value : nil
      
      sinonime_index = cap_tabel.index('sinonime')
      sinonime = sinonime_index ? row[sinonime_index]&.value : nil
      
      selectie_index = cap_tabel.index('selectie')
      selectie = selectie_index ? row[selectie_index]&.value : nil
      
      sel_index = cap_tabel.index('sel')
      sel = sel_index ? row[sel_index]&.value : nil
  
      lista_proprietati = Listaproprietati.new(idx: idx, proprietateter: proprietateter, tipp: tipp, srota: srota, definire: definire, sinonime: sinonime, selectie: selectie, sel: sel)
      if lista_proprietati.save  #salvez in ListaProprietati si apoi apelez met copiere_id_in_recomandari_id pt acopia id in Recomandari
        copiere_id_in_recomandari_id(lista_proprietati[:proprietateter],lista_proprietati[:id]) #pt a crea leg id  de aici cu 
      end  #listaproprietati_id din Recomandari one-to-many
      
    end
    
    if !defined?(@verificare_apelare) || (@verificare_apelare.nil? && !caller.find { |c| c.include?("preluaredate") })
      redirect_to xlsxtopg_index_path, notice: 'Datele au fost preluate cu succes!'
    end
  else
    redirect_to xlsxtopg_index_path, notice: 'Introdu datele mai intai in tabela Recomandari!!'
  end

  end
  def preluaredate5 #importanta
    if Rails.env.production?
      xlsx = Roo::Spreadsheet.open('/opt/render/project/src/app/fisierele/Importanta.xlsx')
    else 
    xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'importanta.xlsx'))
    end
    cap_tabel = xlsx.sheet(0).row(1).map { |col| col.to_s.downcase } # array cu fieldurile din prima linie a fisierului xlsx
     @cap_tabel=cap_tabel
    
    xlsx.each_row_streaming(offset: 1,pad_cells: true) do |row|
      # verificam daca id-ul exista deja in baza de date
      next if Importantum.exists?(codimp: row[cap_tabel.index('codimp')]&.value) if cap_tabel.include?('codimp')
      codimp_index = cap_tabel.index('codimp')
      codimp = codimp_index ? row[codimp_index]&.value : nil 
      grad_index = cap_tabel.index('grad')
      grad = grad_index ? row[grad_index]&.value : nil 
      descgrad_index = cap_tabel.index('descgrad')
      descgrad = descgrad_index ? row[descgrad_index]&.value : nil 

      importanta = Importantum.new(codimp: codimp, grad: grad, descgrad: descgrad)
      importanta.save
      end
      if !defined?(@verificare_apelare) || (@verificare_apelare.nil? && !caller.find { |c| c.include?("preluaredate") })
        redirect_to xlsxtopg_index_path, notice: 'Datele au fost preluate cu succes!'
      end  
    
end
def preluaredate6 #tipuriprop
  if Rails.env.production?
    xlsx = Roo::Spreadsheet.open('/opt/render/project/src/app/fisierele/TipuriProp.xlsx')
  else 
    xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'tipuriprop.xlsx'))
  end
  cap_tabel = xlsx.sheet(0).row(1).map { |col| col.to_s.downcase } # array cu fieldurile din prima linie a fisierului xlsx
  cap_tabel[1] = "explicatie"
  @cap_tabel=cap_tabel
  tab=[1,3,2]
  i=0
  xlsx.each_row_streaming(offset: 1,pad_cells: true) do |row|
    # verificam daca id-ul exista deja in baza de date
    next if TipuriProp.exists?(cp: row[cap_tabel.index('cp')]&.value) if cap_tabel.include?('cp')
    cp_index = cap_tabel.index('cp')
    cp = cp_index ? row[cp_index]&.value : nil 
    explicatie_index = cap_tabel.index('explicatie')
    explicatie = explicatie_index ? row[explicatie_index]&.value : nil 
    

    tipuri = TipuriProp.new(cp: cp, explicatie: explicatie,idxcp: tab[i])
    tipuri.save
    i=i+1
    end
    if !defined?(@verificare_apelare) || (@verificare_apelare.nil? && !caller.find { |c| c.include?("preluaredate") })
      redirect_to xlsxtopg_index_path, notice: 'Datele au fost preluate cu succes!'
    end  
  
end
def preluaredate7 #tipuriprop
  if Rails.env.production?
    xlsx = Roo::Spreadsheet.open('/opt/render/project/src/app/fisierele/Srota.xlsx')
  else  
  xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'srota.xlsx'))
  end


  
  cap_tabel = xlsx.sheet(0).row(1).map { |col| col.to_s.downcase } # array cu fieldurile din prima linie a fisierului xlsx
  @cap_tabel=cap_tabel
  
  xlsx.each_row_streaming(offset: 1,pad_cells: true) do |row|
    # verificam daca id-ul exista deja in baza de date
    next if Srotum.exists?(codsrota: row[cap_tabel.index('codsrota')]&.value) if cap_tabel.include?('codsrota')
    codsrota_index = cap_tabel.index('codsrota')
    codsrota = codsrota_index ? row[codsrota_index]&.value : nil 
    codsr_index = cap_tabel.index('codsr')
    codsr = codsr_index ? row[codsr_index]&.value : nil
    numesrota_index = cap_tabel.index('numesrota')
    numesrota = numesrota_index ? row[numesrota_index]&.value : nil
    numescurt_index = cap_tabel.index('numescurt')
    numescurt = numescurt_index ? row[numescurt_index]&.value : nil
    explicatie_index = cap_tabel.index('explicatie')
    explicatie = explicatie_index ? row[explicatie_index]&.value : nil
    origine_index = cap_tabel.index('origine')
    origine = origine_index ? row[origine_index]&.value : nil
    parti_index = cap_tabel.index('parti')
    parti = parti_index ? row[parti_index]&.value : nil
    functii_index = cap_tabel.index('functii')
    functii = functii_index ? row[functii_index]&.value : nil
    observatie_index = cap_tabel.index('observatie')
    observatie = observatie_index ? row[observatie_index]&.value : nil

    srota = Srotum.new(codsrota: codsrota, codsr: codsr, numesrota: numesrota, numescurt: numescurt,
                      explicatie: explicatie, origine: origine, parti: parti, functii: functii, observatie: observatie)
    srota.save
    end
    

   
    
    
    if !defined?(@verificare_apelare) || (@verificare_apelare.nil? && !caller.find { |c| c.include?("preluaredate") })
      redirect_to xlsxtopg_index_path, notice: 'Datele au fost preluate cu succes!'
    end  
  
end
######################################2 tabele pentru cursul de nutritie
def preluaredate8 #valorinutritionale
  if Rails.env.production?
    xlsx = Roo::Spreadsheet.open('/opt/render/project/src/app/fisierele/valorinutritionale.xlsx')
  else  
    xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'valorinutritionale.xlsx'))
  end
  cap_tabel = xlsx.sheet(0).row(2).map { |col| col.to_s.downcase } # array cu fieldurile din prima linie a fisierului xlsx
  @cap_tabel=cap_tabel
  
  xlsx.each_row_streaming(offset: 2,pad_cells: true) do |row|
    # verificam daca id-ul exista deja in baza de date
    next if Valorinutritionale.exists?(cod: row[cap_tabel.index('cod')]&.value) if cap_tabel.include?('cod') 
    next if row[cap_tabel.index('cod')].value==nil




    cod_index = cap_tabel.index('cod')
    cod = cod_index ? row[cod_index]&.value : nil 

    aliment_index = cap_tabel.index('aliment')
    aliment = aliment_index ? row[aliment_index]&.value : nil

    calorii_index = cap_tabel.index('calorii')
    calorii = calorii_index ? row[calorii_index]&.value : nil

    proteine_index = cap_tabel.index('proteine')
    proteine = proteine_index ? row[proteine_index]&.value : nil

    lipide_index = cap_tabel.index('lipide')
    lipide = lipide_index ? row[lipide_index]&.value : nil

    carbohidrati_index = cap_tabel.index('carbohidrati')
    carbohidrati = carbohidrati_index ? row[carbohidrati_index]&.value : nil

    fibre_index = cap_tabel.index('fibre')
    fibre = fibre_index ? row[fibre_index]&.value : nil

    

    valorinutritionale = Valorinutritionale.new(cod: cod, aliment: aliment, calorii: calorii, proteine: proteine,
                      lipide: lipide, carbohidrati: carbohidrati, fibre: fibre)
    valorinutritionale.save
    end
    
   
    
    
    if !defined?(@verificare_apelare) || (@verificare_apelare.nil? && !caller.find { |c| c.include?("preluaredate") })
      redirect_to xlsxtopg_index_path, notice: 'Datele au fost preluate cu succes!'
    end  
  
end
def preluaredate9 #valorinutritionale update la campul observatii
  Valorinutritionale.update_all(observatii: 'Informatiile din aceasta aplicatie sunt cele oferite public de catre producator')
end  
def preluaredate10 #listavegetale
  if Rails.env.production?
    xlsx = Roo::Spreadsheet.open('/opt/render/project/src/app/fisierele/listavegetale.xlsx')
  else 
    xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'listavegetale.xlsx'))
  end

  xlsx.each_row_streaming(offset: 1, pad_cells: true) do |row|
    specie = row[0]&.value
    sinonime = row[1]&.value
    parteutilizata = row[2]&.value
    mentiunirestrictii = row[3]&.value
    numar = row[4]&.value  # Adaugăm această linie
    dataa = row[5]&.value  # Adaugăm această linie

    # Doar dacă cel puțin o valoare nu este goală sau nulă, salvează înregistrarea
    if [specie, sinonime, parteutilizata, mentiunirestrictii, numar, dataa].any?(&:present?)
      lista_vegetale = ListaVegetale.new(specie: specie, sinonime: sinonime, parteutilizata: parteutilizata, mentiunirestrictii: mentiunirestrictii, numar: numar, dataa: dataa)
      lista_vegetale.save
    end
  end

  if !defined?(@verificare_apelare) || (@verificare_apelare.nil? && !caller.find { |c| c.include?("preluaredate") })
    redirect_to xlsxtopg_index_path, notice: 'Datele au fost preluate cu succes!'
  end  
end

def preluaredate11 #preluare useri noi (doar noi ) doar atat. email,name,pass,role,telefon
  #acum e optim pt a prelua din excel email,name,telefon
  xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'adaugauseri.xlsx'))

  xlsx.each_row_streaming(offset: 0) do |row|
    email = row[0]&.value&.strip&.downcase # Adăugat downcase
    name = row[1]&.value&.strip
    #limba = row[2]&.value&.strip
    telefon = row[2]&.value&.to_s&.strip


    # Sari peste rând dacă email este nul
    next if email.nil?

    # Verifică dacă email-ul există deja în tabel
    next if User.exists?(email: email.downcase) # Adăugat downcase și aici, pentru consistență

    # Crează un nou utilizator
    user = User.new(email: email, name: name, telefon: telefon, password: "7777777", role: 0)

    # Salvează utilizatorul
    if user.save
      puts "Utilizatorul #{email} a fost adăugat cu succes."
    else
      puts "Eroare la adăugarea utilizatorului #{email}: #{user.errors.full_messages.join(', ')}"
    end
  end
end

def preluaredate12 # pune in tabela Userprod userii din tabela preluata mai sus user_id si prod_id (pt a controla userii 
  #userii care sa aiba acces sa cumpere un produs aici produsul care are cod=cod9 )
  # acum am pus cod11 : pot cumpara acces la un produs de tip nutritie3 (oricare dc pun cod11)
  xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'adaugauseri.xlsx'))

  # Găsește produsul cu codul 'cod9'
  prod = Prod.find_by(cod: 'cod11')

  # Dacă produsul nu există, iesi din metodă
  return unless prod

  xlsx.each_row_streaming(offset: 0) do |row|
    email = row[0]&.value&.strip&.downcase # Adăugat downcase aici
    next unless email

    # Caută userul cu email-ul dat
    user = User.find_by(email: email)
    next unless user

    # Creează o înregistrare în Userprod doar dacă nu există deja
    Userprod.find_or_create_by(user: user, prod: prod)
  end
end
#preluaredate11 12 si 13 sunt legate  am 3 butoane poti apasa aoricat pe ele pt ca se preia doar ce nu e deja bagat
def preluaredate13  #verifica daca s-au preluat toti userii din tabela de mai sus si afiseaza userii nepreluati
  xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'adaugauseri.xlsx'))
  @emails_negasite = []

  xlsx.each_row_streaming(offset: 0) do |row|
    email = row[0]&.value&.strip&.downcase # Adăugat downcase aici
    next unless email

    # Verifică dacă userul cu email-ul dat există
    unless User.exists?(email: email)
      @emails_negasite << email
    end
  end

  if @emails_negasite.any?
    flash[:alert] = "Următoarele adrese de email nu au fost găsite: #{@emails_negasite.join(', ')}"
  else
    flash[:notice] = "Toate adresele de email din fișierul XLSX sunt în tabela User."
  end
end



def preluaredate14 #preia din tabela excel telefoanele si le pune la useri
  xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'adaugauseri.xlsx'))

  xlsx.each_row_streaming(offset: 0) do |row|
    email = row[0]&.value&.strip&.downcase # Adăugat downcase
    name = row[1]&.value&.strip
    telefon = row[2]&.value&.strip

    # Sari peste rând dacă email sau telefon este nul
    next if email.nil? || telefon.nil?

    # Găsește utilizatorul cu email-ul specificat
    user = User.find_by(email: email.downcase)

    # Dacă utilizatorul există, actualizează numărul de telefon
    if user
      if user.update(telefon: telefon)
        puts "Numărul de telefon pentru utilizatorul #{email} a fost actualizat cu succes."
      else
        puts "Eroare la actualizarea numărului de telefon pentru utilizatorul #{email}: #{user.errors.full_messages.join(', ')}"
      end
    else
      puts "Nu s-a găsit niciun utilizator cu email-ul #{email}."
    end
  end
end
############################################################
#an1 
#vezi modelul de fisier xlsx adaugauseri.xlsx in G:\Index A\fisiere excel\cursanti cursuri ayurveda\an 1
# este cu cap de tabel: Grupa	Adresa de e-mail	Nume	Telefon	Plata inscr	Plata oct 2023	Plata nov 2023	Plata dec 2023	Plata ian 2024	
#Plata feb 2024	Plata mar 2024	Plata apr 2024	Plata mai 2024	Plata iun 2024	Plata iul 2024

###############################################################
def preluaredate15 #preluare useri noi (doar noi ) doar atat. grupa email,name,pass,role,telefon
  #pot prelua de mai multe ori daca deja exista nu se petrece nimic; sunt pusi doar cei noi
  xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'adaugauseri.xlsx'))

  xlsx.each_row_streaming(offset: 1) do |row|
    grupa = row[0]&.value&.to_s&.strip
    email = row[1]&.value&.strip&.downcase # Adăugat downcase
    name = row[2]&.value&.strip
    telefon = row[3]&.value&.to_s&.strip

    # Sari peste rând dacă email este nul
    next if email.nil?

    # Verifică dacă email-ul există deja în tabel
    next if User.exists?(email: email.downcase) # Adăugat downcase și aici, pentru consistență

    # Crează un nou utilizator
    user = User.new(grupa: grupa, email: email, name: name,telefon: telefon, password: "7777777", role: 0)

    # Salvează utilizatorul
    if user.save
      puts "Utilizatorul #{email} a fost adăugat cu succes."
    else
      puts "Eroare la adăugarea utilizatorului #{email}: #{user.errors.full_messages.join(', ')}"
    end
  end
end
##########################################################################
def preluaredate16  #fac update la grupa pentru toti userii din tabela xlsx cu ce este gasit in xlsx

  xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'adaugauseri.xlsx'))

  xlsx.each_row_streaming(offset: 1) do |row|
    grupa_noua = row[0]&.value&.to_s&.strip
    email = row[1]&.value&.to_s&.strip&.downcase

    next if email.blank? || grupa_noua.blank?

    # Caută utilizatorul cu emailul specificat
    user = User.find_by(email: email)

    # Dacă utilizatorul există, actualizează grupa
    if user
      user.update(grupa: grupa_noua)
      puts "Grupa utilizatorului #{email} a fost actualizată cu succes la #{grupa_noua}."
    else
      puts "Nu s-a găsit niciun utilizator cu emailul #{email}."
    end
  end
end
##########################################################################
def preluaredate17 # fac update la telefon pentru toti userii din tabela xlsx cu ce este gasit in xlsx
  xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'adaugauseri.xlsx'))
  

  xlsx.each_row_streaming(offset: 1) do |row|
    telefon_nou = row[3]&.value&.to_s&.strip
    email = row[1]&.value&.to_s&.strip&.downcase

    next if email.blank?

    # Caută utilizatorul cu emailul specificat
    user = User.find_by(email: email)

    # Dacă utilizatorul există, și telefon_nou este prezent, actualizează telefonul
    if user
      if telefon_nou.present?
        user.update(telefon: telefon_nou)
        puts "Telefonul utilizatorului #{email} a fost actualizat cu succes la #{telefon_nou}."
      else
        puts "Telefonul utilizatorului #{email} nu a fost modificat deoarece nu a fost furnizată o valoare nouă."
      end
    else
      puts "Nu s-a găsit niciun utilizator cu emailul #{email}."
    end
  end
end
##########################################################################

#an2
############################################################
#an1 
#vezi modelul de fisier xlsx adaugauseri.xlsx in G:\Index A\fisiere excel\cursanti cursuri ayurveda\an 1
# este cu cap de tabel: Grupa	Adresa de e-mail	Nume	Telefon	Plata inscr	Plata oct 2023	Plata nov 2023	Plata dec 2023	Plata ian 2024	
#Plata feb 2024	Plata mar 2024	Plata apr 2024	Plata mai 2024	Plata iun 2024	Plata iul 2024

###############################################################
def preluaredate18 #preluare useri noi (doar noi ) doar atat. grupa email,name,pass,role,telefon
  #pot prelua de mai multe ori daca deja exista nu se petrece nimic; sunt pusi doar cei noi
  xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'adaugauseri.xlsx'))

  xlsx.each_row_streaming(offset: 1) do |row|
    grupa = row[0]&.value&.to_s&.strip
    email = row[1]&.value&.strip&.downcase # Adăugat downcase
    name = row[2]&.value&.strip
    telefon = row[3]&.value&.to_s&.strip

    # Sari peste rând dacă email este nul
    next if email.nil?

    # Verifică dacă email-ul există deja în tabel
    next if User.exists?(email: email.downcase) # Adăugat downcase și aici, pentru consistență

    # Crează un nou utilizator
    user = User.new(grupa: grupa, email: email, name: name,telefon: telefon, password: "7777777", role: 0)

    # Salvează utilizatorul
    if user.save
      puts "Utilizatorul #{email} a fost adăugat cu succes."
    else
      puts "Eroare la adăugarea utilizatorului #{email}: #{user.errors.full_messages.join(', ')}"
    end
  end
end
##########################################################################
def preluaredate19  #fac update la grupa pentru toti userii din tabela xlsx cu ce este gasit in xlsx

  xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'adaugauseri.xlsx'))

  xlsx.each_row_streaming(offset: 1) do |row|
    grupa_noua = row[0]&.value&.to_s&.strip
    email = row[1]&.value&.to_s&.strip&.downcase

    next if email.blank? || grupa_noua.blank?

    # Caută utilizatorul cu emailul specificat
    user = User.find_by(email: email)

    # Dacă utilizatorul există, actualizează grupa
    if user
      user.update(grupa: grupa_noua)
      puts "Grupa utilizatorului #{email} a fost actualizată cu succes la #{grupa_noua}."
    else
      puts "Nu s-a găsit niciun utilizator cu emailul #{email}."
    end
  end
end
##########################################################################
def preluaredate20 # fac update la telefon pentru toti userii din tabela xlsx cu ce este gasit in xlsx
  xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'adaugauseri.xlsx'))
  

  xlsx.each_row_streaming(offset: 1) do |row|
    telefon_nou = row[3]&.value&.to_s&.strip
    email = row[1]&.value&.to_s&.strip&.downcase

    next if email.blank?

    # Caută utilizatorul cu emailul specificat
    user = User.find_by(email: email)

    # Dacă utilizatorul există, și telefon_nou este prezent, actualizează telefonul
    if user
      if telefon_nou.present?
        user.update(telefon: telefon_nou)
        puts "Telefonul utilizatorului #{email} a fost actualizat cu succes la #{telefon_nou}."
      else
        puts "Telefonul utilizatorului #{email} nu a fost modificat deoarece nu a fost furnizată o valoare nouă."
      end
    else
      puts "Nu s-a găsit niciun utilizator cu emailul #{email}."
    end
  end
end
##########################################################################
def preluaredate21
  # Deschide fișierul xlsx
  xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'adaugauseri.xlsx'))

  # Parcurge fiecare rând din fișier
  xlsx.each_row_streaming(offset: 0) do |row|
    # Extrage valoarea emailului și normalizează-o (înlătură spațiile și convertește la litere mici)
    email = row[0]&.value&.strip&.downcase
    next unless email

    # Caută userul cu email-ul dat
    user = User.find_by(email: email)
    next unless user

    # Actualizează valoarea nutritieabsolvit cu 2
    user.update(nutritieabsolvit: 2)
  end
end
def preluaredate22 # pune inregistri in tabela UserModulecursuri doar daca combinatia user.id, modulecursuri_id nu exista
  #deci pot veni cu o tabela noua si sa o rulez - nu va crea duplicate va pune doar ce e nou
  #in cazul meu modulecursuri_id  1  si 2 corespund cursului de Nutritie modulul 1 p1 si modulul 1 p2
  #daca vreau sa adaug pentru Nutritie 2 acestuia ii corespunde-vezi in tabela Modulecursuri - acolo e 3
  #daca vreau sa adaug pentru Nutritie 3 acestuia ii corespunde-vezi in tabela Modulecursuri - acolo e 4
  #Mare atentie daca folosesc id: modulecursuri_id: 4  acum Nutritie3 are id 4 dar vezi sa nu se schimbe!!! daca stergi si pui la loc

  xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'adaugauseri.xlsx'))
 
  xlsx.each_row_streaming(offset: 0) do |row|
    email = row[0]&.value&.strip&.downcase
    name = row[1]&.value&.strip
    telefon = row[2]&.value&.to_s&.strip

    absolvit = row[4]&.value&.strip
    absolvit = row[3]&.value&.strip if absolvit.nil?

    # Sari peste rând dacă email este nul
    next if email.nil?

    # Caută userul în baza de date
    user = User.find_by(email: email)

    # Verifică dacă userul există și procesează în funcție de valoarea lui 'absolvit'
    if user
     
      case absolvit
      when "p1 si p2"
        UserModulecursuri.find_or_create_by(user_id: user.id, modulecursuri_id: 1, validat: "Finalizata")
        UserModulecursuri.find_or_create_by(user_id: user.id, modulecursuri_id: 2, validat: "Finalizata")
      when "doar p1"
        UserModulecursuri.find_or_create_by(user_id: user.id, modulecursuri_id: 1, validat: "Finalizata")
      end
    end
   

  end
end

def preluaredate23
  # Parcurge toți userii
  User.where(nutritieabsolvit: 2).each do |user|
    # Pentru fiecare user care are nutritieabsolvit == 2,
    # creează o înregistrare în UserModulecursuri
    UserModulecursuri.find_or_create_by(user_id: user.id, modulecursuri_id: 3, validat: "Finalizata")
  end
end




######################################
  def sterge_inregistrari
    Plante.destroy_all
    PlanteParti.destroy_all
    Recomandari.destroy_all
    Listaproprietati.destroy_all
    Importantum.destroy_all
    TipuriProp.destroy_all
    Srotum.destroy_all
    redirect_to xlsxtopg_index_path, notice: 'Toate înregistrările au fost șterse!'
  end
  def sterge_inregistrari1
    Plante.destroy_all
    redirect_to xlsxtopg_index_path, notice: 'Toate înregistrările din tabela Plante au fost șterse!'
  end
  def sterge_inregistrari2
    PlanteParti.destroy_all
    redirect_to xlsxtopg_index_path, notice: 'Toate înregistrările din tabela Plante-Parti au fost șterse!'
  end
  def sterge_inregistrari3
    Recomandari.destroy_all
    redirect_to xlsxtopg_index_path, notice: 'Toate înregistrările din tabela Recomandari au fost șterse!'
  end
  def sterge_inregistrari4
    Listaproprietati.destroy_all
    redirect_to xlsxtopg_index_path, notice: 'Toate înregistrările din tabela Lista Proprietati au fost șterse!'
  end
  def sterge_inregistrari5
    Importantum.destroy_all
    redirect_to xlsxtopg_index_path, notice: 'Toate înregistrările din tabela Importanta au fost șterse!'
  end
  def sterge_inregistrari6
    TipuriProp.destroy_all
    redirect_to xlsxtopg_index_path, notice: 'Toate înregistrările din tabela Lista Tipuri Proprietati au fost șterse!'
  end
  def sterge_inregistrari7
    Srotum.destroy_all
    redirect_to xlsxtopg_index_path, notice: 'Toate înregistrările din tabela Lista Tipuri Proprietati au fost șterse!'
  end
  def sterge_inregistrari8
    Valorinutritionale.destroy_all
    redirect_to xlsxtopg_index_path, notice: 'Toate înregistrările din tabela Valori Nutritionale au fost șterse!'
  end
  def sterge_inregistrari10
    ListaVegetale.destroy_all
    redirect_to xlsxtopg_index_path, notice: 'Toate înregistrările din tabela Lista Vegetale au fost șterse!'
  end
  
  def test
    xlsx = Roo::Spreadsheet.open(File.join(Rails.root, 'app', 'fisierele', 'Lista_proprietati.xlsx'))
    #@row0=xlsx.sheet(0).row(1)   
    cap_tabel = xlsx.sheet(0).row(1).map { |col| col.to_s.downcase } # array cu fieldurile din prima linie a fisierului xlsx
    
    @row0=cap_tabel
  end 
  private
  def copiere_id_in_recomandari_id(pter,id1)
    id1=id1
    proprietate = pter
    Recomandari.where(proprietate: proprietate).update_all(listaproprietati_id: id1)
  end  
  def require_admin
    unless current_user && current_user.role == 1
      flash[:error] = "Only admins are allowed to access this page."
      redirect_to root_path # sau o altă cale pe care doriți să o redirecționați utilizatorul
    end
  end
end

