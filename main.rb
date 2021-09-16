require 'ruby_grammar_builder'

g = Grammar.new name: "F# Templates",
                scope_name: "template.fsharp.injection",
                ending: "",
                injectionSelector: "L:source.fsharp - (comment, string.quoted.double.fsharp, string.quoted.triple.fsharp)"

def P(*a) Pattern.new(*a) end
def PR(*a) PatternRange.new(*a) end
def I(i,l)
    
    s = P tag_as: "punctuation.section.attribute.begin",
          match: P(/[ ._]/).then(match: i, tag_as: "variable.fsharp").then(/ *(?:(?=\$)|$)/)
    
    e = P tag_as: "punctuation.section.attribute.end",
          match: /"""/
    
    n = PR tag_content_as: "template.fsharp.html",
           start_pattern: /\$"""/,
           end_pattern: /(?=""")/,
           includes: [l]
    
    c = n, "source.fsharp"
    
    PR start_pattern: s,
       end_pattern: e,
       includes: c
end

g[:$initial_context] = I( /html|svg/, "text.html.derivative" ), I( /sql/, "source.sql" )
g.save_to syntax_name: "o"