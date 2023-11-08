module Tayt12Helper
    def has_required_products?(user, required_cod)
        return false unless user
        
        required_products = Prod.where(cod: required_cod)
        user.comenzi_prods.where(prod_id: required_products.map(&:id), validat: "Finalizata").exists?
      end
    
      def has_purchased_product?(user, products)
        return false unless user
    
        ComenziProd.where(user_id: user.id, prod_id: products.map(&:id), validat: "Finalizata").exists?
      end
end
