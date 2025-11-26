# frozen_string_literal: true

module Jekyll
  class BlueskyTag < Liquid::Tag
    def initialize(tag_name, url, tokens)
      super
      @url = url.strip
    end

    def render(context)
      # Extract post information from Bluesky URL
      # URL format: https://bsky.app/profile/{handle}/post/{post_id}
      if @url =~ %r{bsky\.app/profile/([^/]+)/post/([^/\s]+)}
        handle = Regexp.last_match(1)
        post_id = Regexp.last_match(2)
        
        # Create an embedded iframe using Bluesky's post URL
        # Note: Bluesky doesn't have official embed iframe yet, so we use a blockquote with link
        <<~HTML
          <blockquote class="bluesky-embed" data-lang="en">
            <p lang="en" dir="ltr">
              <a href="#{@url}" target="_blank" rel="noopener noreferrer">View post on Bluesky</a>
            </p>
            &mdash; <a href="https://bsky.app/profile/#{handle}" target="_blank" rel="noopener noreferrer">@#{handle}</a>
          </blockquote>
          <script>
            // Future: Add Bluesky embed script when officially available
            // For now, this creates a styled link to the post
          </script>
          <style>
            .bluesky-embed {
              border: 1px solid #e1e8ed;
              border-radius: 12px;
              padding: 16px;
              margin: 20px 0;
              background-color: #f8f9fa;
              font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, Helvetica, Arial, sans-serif;
            }
            .bluesky-embed p {
              margin: 0 0 8px 0;
            }
            .bluesky-embed a {
              color: #1185fe;
              text-decoration: none;
            }
            .bluesky-embed a:hover {
              text-decoration: underline;
            }
            html[data-theme='dark'] .bluesky-embed {
              background-color: #1e1e1e;
              border-color: #3a3a3a;
            }
          </style>
        HTML
      else
        "<p>Invalid Bluesky URL: #{@url}</p>"
      end
    end
  end
end

Liquid::Template.register_tag('bluesky', Jekyll::BlueskyTag)
