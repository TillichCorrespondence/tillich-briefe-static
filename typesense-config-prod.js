const config = {
  server: {
    apiKey: "QvDKjXWPlDOOQzYWM2ao4a4f7aPlWCcb",
    nodes: [
      {
        host: "z4jbuvfnwcpa07iqp-1.a1.typesense.net",
        port: "443",
        protocol: "https",
      },
    ],
    cacheSearchResultsForSeconds: 2 * 60,
  },
  additionalSearchParameters: {
    query_by: "full_text",
  },
};
