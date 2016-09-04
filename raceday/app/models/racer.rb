class Racer
	attr_accessor :id, :number, :first_name, :last_name, :gender, :group, :secs

	def self.mongo_client
		Mongoid::Clients.default
	end

	def self.collection
		self.mongo_client['racers']
	end

	def self.all(prototype={},sort={},skip=0,limit=nil)
	    Rails.logger.debug {"getting all zips, prototype=#{prototype}, sort=#{sort}, skip=#{skip}, limit=#{limit}"}

	    result=collection.find(prototype)
	          .projection({_id: true, number: true, first_name: true, last_name: true, gender: true, group: true, secs: true})
	          .sort(sort)
	          .skip(skip)
	    result=result.limit(limit) if !limit.nil?

	    return result
  	end

  	def initialize(params={})
		@id=params[:_id].nil? ? params[:id] : params[:_id].to_s
		@number=params[:number].to_i
		@first_name=params[:first_name]
		@last_name=params[:last_name]
		@gender=params[:gender]
		@group=params[:group]
		@secs=params[:secs].to_i
	end

	def self.find id
		result=collection.find(:_id=> BSON::ObjectId.from_string(id))
			   .projection({_id: true, number: true, first_name: true, last_name: true, gender: true, group: true, secs: true})
			   .first
		return result.nil? ? nil : Racer.new(result)
	end

	def created_at
		nil
	end

	def updated_at
		nil
	end
end