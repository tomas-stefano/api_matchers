# frozen_string_literal: true

module APIMatchers
  module Hateoas
    class HaveLink < Base
      def initialize(rel)
        @rel = rel.to_s
        @expected_href = nil
        @href_pattern = nil
      end

      def with_href(href_or_pattern)
        case href_or_pattern
        when Regexp
          @href_pattern = href_or_pattern
        else
          @expected_href = href_or_pattern.to_s
        end
        self
      end

      def failure_message
        links = hateoas_links

        if links.nil?
          "expected response to have link '#{@rel}', but no links were found. " \
            "Looked at '#{links_path}'. Got: #{truncate_json(parsed_json)}"
        elsif !link_exists?(links)
          "expected response to have link '#{@rel}'. " \
            "Available links: #{available_rels(links).inspect}"
        elsif @expected_href
          "expected link '#{@rel}' to have href '#{@expected_href}'. " \
            "Got: '#{extract_href(links)}'"
        elsif @href_pattern
          "expected link '#{@rel}' href to match #{@href_pattern.inspect}. " \
            "Got: '#{extract_href(links)}'"
        else
          "expected response to have link '#{@rel}'"
        end
      end

      def failure_message_when_negated
        if @expected_href
          "expected link '#{@rel}' NOT to have href '#{@expected_href}', but it did"
        elsif @href_pattern
          "expected link '#{@rel}' NOT to match #{@href_pattern.inspect}, but it did"
        else
          "expected response NOT to have link '#{@rel}', but it was present"
        end
      end

      def description
        desc = "have link '#{@rel}'"
        desc += " with href '#{@expected_href}'" if @expected_href
        desc += " matching #{@href_pattern.inspect}" if @href_pattern
        desc
      end

      protected

      def perform_match
        links = hateoas_links
        return false unless links.is_a?(Hash)
        return false unless link_exists?(links)

        href = extract_href(links)

        if @expected_href
          href == @expected_href
        elsif @href_pattern
          href.to_s.match?(@href_pattern)
        else
          true
        end
      end

      private

      def link_exists?(links)
        links.key?(@rel) || links.key?(@rel.to_sym)
      end

      def extract_href(links)
        link = links[@rel] || links[@rel.to_sym]
        return nil unless link

        case link
        when Hash
          link['href'] || link[:href]
        when String
          link
        else
          nil
        end
      end

      def available_rels(links)
        links.keys.map(&:to_s)
      end
    end
  end
end
