require 'ruby_grammar_builder'

g = Grammar.new name: "F# Templates",
                scope_name: "template.fsharp.injection",
                ending: "",
                injectionSelector: "L:source.fsharp - (comment, string.quoted.double.fsharp, string.quoted.triple.fsharp)"

def format_str(pat, with)    
    start = Pattern.new tag_as: "punctuation.section.attribute.begin",
                        match: Pattern.new(/[ ._]/).then(match: pat, tag_as: "variable.fsharp").then(/ *(?:(?=\$)|$)/)
    
    stop = Pattern.new tag_as: "punctuation.section.attribute.end",
                       match: /"""/
    
    inner = PatternRange.new tag_content_as: "template.fsharp.html",
                             start_pattern: /\$"""/,
                             end_pattern: /(?=""")/,
                             includes: [with]
    
    context = inner, "source.fsharp"
    
    PatternRange.new start_pattern: start,
                     end_pattern: stop,
                     includes: context
end

g[:$initial_context] = format_str(/html|svg/, "text.html.derivative"), format_str(/sql/, "source.sql")
g.save_to syntax_name: "o"