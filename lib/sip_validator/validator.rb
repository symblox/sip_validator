require 'active_model'

module SipValidator
  class Validator
    def initialize(opts = {})
      # ruby does not allow method with -
      # replaces - with _
      opts.keys.each do |key|
        raise("#{key} incude _ which is not allowed") if key.to_s.match(/_/)
        if key.to_s.match(/-/)
          new_key = opts.keys.last.to_s.gsub('-','_')
          opts[new_key] = opts.delete key
        end
      end
      super(opts)
    end

    include ActiveModel::Model
    attr_accessor :sip, :sccp, :title, :author, :status, :created, :updated
    attr_accessor :replaces, :requires, :layer, :resolution
    # replace - with _
    attr_accessor :discussions_to, :superseded_by, :review_period_end
    validates_presence_of :title, :author, :status, :created
    validates :sip,
              presence: true,
              unless: ->(v){v.sccp.present?}
    validates :sccp, 
              presence: true, 
              unless: ->(v){v.sip.present?}
    validates_inclusion_of :status, in: ['WIP', 'Proposed', 'Approved', 'Implemented', 'Rejected']
  end
end

