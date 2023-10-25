module VideosHelper
    def has_purchased_product?(user, products)
        return false unless user
      
        ComenziProd.where(user_id: user.id, prod_id: products.map(&:id), validat: "Finalizata").exists?
      end
      
end
