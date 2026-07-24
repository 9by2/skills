# Artifact revisions API

Public revision index used by the template sidebar dropdown.

## Endpoint

```http
GET /artifact/:id/revisions
```

Hosted example: `https://artifact.9by2.workers.dev/artifact/:id/revisions`

## Response

```json
{
  "id": "5IkXee4wm-HVnso_yqliJ",
  "published": "019f8fc4-2cf5-71d4-b206-62364b571f16",
  "revisions": [
    {
      "id": "019f8fc4-2cf5-71d4-b206-62364b571f16",
      "status": "published",
      "createdAt": 1784823426,
      "publishedAt": 1784823428,
      "revisionPath": "/artifact/5IkXee4wm-HVnso_yqliJ/revision/019f8fc4-2cf5-71d4-b206-62364b571f16/"
    }
  ]
}
```

| Field | Notes |
| --- | --- |
| `id` | Stable artifact id |
| `published` | Revision id currently served at `/artifact/:id` |
| `revisions[].id` | Immutable revision id |
| `revisions[].status` | e.g. `published` |
| `revisions[].createdAt` / `publishedAt` | Unix seconds |
| `revisions[].revisionPath` | Navigate here on dropdown change |

## Template behavior

Copy from `asset/index.template.html`:

1. Parse artifact id (and optional current revision) from `location.pathname`
2. `fetch("/artifact/:id/revisions")` only when the path matches `/artifact/…`
3. Fill `#revision-select`; show `#revision-switcher` when options exist
4. On change → `location.assign(revisionPath)` (preserve hash)
5. If fetch fails (local `file:` / `serve`), leave the control hidden

Do not hardcode a third-party revision UI. Keep this contract in sync with the
Worker.
