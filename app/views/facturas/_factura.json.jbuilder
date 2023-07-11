json.extract! factura, :id, :comanda_id, :user_id, :numar, :numar_comanda, :data_emiterii, :prenume, :nume, :nume_companie, :cui, :tara, :localitate, :judet, :cod_postal, :strada, :numar_adresa, :produs, :cantitate, :pret_unitar, :valoare_tva, :valoare_totala, :created_at, :updated_at
json.url factura_url(factura, format: :json)
