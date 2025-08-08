## Deploy Check

Intention de pré-déploiement pour vérifier qu’un candidat à la mise en production est prêt et sûr pour l’environnement cible.

### Usage

```bash
/deploy-check [--env <staging|production|custom>] [--smoke-url <url>] [--migrations] [--strict]
```

### Options

- `--env <staging|production|custom>` : Environnement cible (influence les contrôles requis)
- `--smoke-url <url>` : Endpoint santé/smoke à vérifier après déploiement (si disponible)
- `--migrations` : Inclure les contrôles de préparation des migrations DB (dry-run/plan)
- `--strict` : Renforcer les portes de sécurité (0 vulnérabilités, pas de TODO/FIXME, seuil de couverture, etc.)
- `--template` : Afficher un modèle Markdown standard de checklist (pour artefacts CI ou revue manuelle)

### Exemples

```bash
# Modèle de checklist standard
/deploy-check --template
"Affiche un checklist Markdown à copier dans le ticket de déploiement."
```

```bash
# Pré-déploiement vers staging
/deploy-check --env staging --smoke-url https://staging.example.com/health
"Utilise les sorties build/test/audit et les variables d’environnement ci-dessous pour juger la préparation et lister les bloqueurs avec remédiations."

# Production avec migrations
/deploy-check --env production --migrations --strict
"Contraintes de temps d’arrêt minimales. Valider aussi la stratégie de rollback et la dérive de configuration."
```

### Intégration Claude

Collez des extraits concis (logs lint/test/build/audit, env requis masqués, plan de migration, résumé infra) puis exécutez:

```bash
/deploy-check --env production --migrations --strict
"Produis une checklist PASS/FAIL. Pour chaque échec, donne des étapes/commandes concrètes. Ajoute l’évaluation des risques, le plan de rollback et les étapes de smoke (curl <url> / vérifier les logs)."
```

### Ce que fait cette commande

- Agrège les contrôles de pré-déploiement en une checklist vérifiable
- Utilise le contexte fourni par l’utilisateur pour décider PASS/FAIL
- Fournit les remédiations concrètes, un mini plan de smoke et un plan de rollback

### Modèle (extrait)

```
# Checklist de Préparation au Déploiement
- [ ] Branche propre (aucune modif non commit)
- [ ] Synchronisé avec main (HEAD == origin/main ou justification)
- [ ] Lint OK
- [ ] Type-check OK (si applicable)
- [ ] Tests unitaires OK
- [ ] E2E OK (ou justification)
- [ ] Build OK
- [ ] Audit sécurité: 0 critique/élevée (mitigations listées)
- [ ] Vars d’env requises: API_URL, DATABASE_URL, SECRET_KEY
- [ ] Migrations revues (plan/dry-run joint)
- [ ] Dérive infra/config vérifiée (IaC, tags d’image, replicas)
- [ ] Plan de rollback documenté
- [ ] Smoke post-déploiement: curl <SMOKE_URL> + vérif des logs
```

### Commandes liées

- `/pr-check` – Portes de qualité avant PR
- `/test-e2e-local` – Validation E2E locale
- `/check-github-ci` – Suivi de l’état CI

