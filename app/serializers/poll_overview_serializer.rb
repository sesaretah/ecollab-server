class PollOverviewSerializer < ActiveModel::Serializer
  attributes :id, :content, :answer_type, :answer_content, :stats

  def stats
    if object.answer_type == "binary"
      yes_count = object.pollings.where(outcome: 1).count
      no_count = object.pollings.where(outcome: -1).count
      answer = { '1': yes_count, '-1': no_count }
    end
    if object.answer_type == "trinary"
      yes_count = object.pollings.where(outcome: 1).count
      abstention_count = object.pollings.where(outcome: 0).count
      no_count = object.pollings.where(outcome: -1).count
      answer = { '1': yes_count, '-1': no_count, '0': abstention_count }
    end
    if object.answer_type == "single_select"
      answer = {}
      for i in 0..(object.answer_content.length - 1)
        count = object.pollings.where(outcome: i).count
        answer["#{i}"] = count
      end
    end

    if object.answer_type == "multiple_select"
      answer = {}
      for i in 0..(object.answer_content.length - 1)
        count = 0
        for polling in object.pollings
          count += 1 if polling.outcomes.include? i
        end
        answer["#{i}"] = count
      end
    end
    return answer
  end

  def pollable_link
    "#{object.pollable_type.underscore.pluralize}/#{object.pollable_id}"
  end
end
