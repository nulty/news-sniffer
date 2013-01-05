module FeedsPortalParser
	require 'oniguruma'
	include Oniguruma

	FP_RE = ORegexp.new("0L0S[a-zA-Z0-9]+html")
		#"(irishtimes).{4}(newspaper).{2}(breaking|finance|world|ireland).{2}([0-9]{2}).([0-9]{2}).{2}([A0-9]{4,6}).{2}([A-Z0-9]+)(html)")

	# Convert a Feedsportal RSS link to regular url for parser
	def convert_feedsportal(feedsp_url)
		m_data = FP_RE.match(feedsp_url)
		return feedsp_url if m_data.nil?
		return m_data[0].
		gsub("0L0S", "http://www.").
		gsub("0N0C", ".com/").
		gsub("0A", "0").
		gsub("0C", "/").
		gsub("0B", ".").
		gsub("0E", "-")

	end
end
