class ThesisParser

  TEXT_AREA_START_TAG = "#start#"
  TEXT_AREA_END_TAG = "#stop#"
  TEXT_AREA_ID = "example_code_#"

  def self.parse(file)
    data = ""
    code_data = ""
    id = 0
    recording = false
    file.each_line do |line|
      if line =~ /#{TEXT_AREA_START_TAG}/
        recording = true 
        id += 1
      end
      if recording
        code_data += line unless line =~ /#{TEXT_AREA_START_TAG}/ or line =~ /#{TEXT_AREA_END_TAG}/
      else
        data += line
      end
      if line =~ /#{TEXT_AREA_END_TAG}/ and recording
        data += "<pre>"
        data += TEXT_AREA_START_TAG.sub("#start#", "<textarea class='code' id='#{TEXT_AREA_ID + id.to_s}'>")
        data += code_data
        data += "</textarea>"
        data += "</pre>"
        data += put_try_textarea(id, code_data)
        recording = false
        code_data = ""
      end
    end
    return data
  end

  private

  def self.put_try_textarea(id, data)
    html = "<a href='#' id='show_try_code_##{id}_button' class='button show-try-code' data-textarea='try_code_##{id}'>Vyzkoušet</a>"
    html << "<textarea style='display: none' class='try-code' id='try_code_##{id}'></textarea>"
    html << "<pre id='try_code_##{id}_output' class='code-output' style='display: none'></pre>"
    html << "<div class='try-code-buttons'>"
    html << "<a href='#' id='try_code_##{id}_button' style='display: none' class='button try-code' data-textarea='try_code_##{id}'>Odeslat</a>"
    html << "<a href='#' id='cancel_try_code_##{id}_button' style='display: none' class='button cancel-try-code' data-textarea='try_code_##{id}'>Zavřít</a>"
    html << "</div>"
  end

end