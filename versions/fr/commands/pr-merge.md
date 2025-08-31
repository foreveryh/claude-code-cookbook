## Fusion PR

Fusionner automatiquement les Pull Requests après vérification complète de la qualité et approbation.

### Utilisation

```bash
# Fusion automatique après validation des critères de qualité
/pr-merge
"Vérifier tous les critères de qualité et fusionner automatiquement la PR actuelle"

# Fusionner une PR spécifique avec vérification
/pr-merge --pr 123
"Vérifier et fusionner la PR #123 après validation de tous les contrôles"

# Exécution à blanc pour vérifier l'état de fusion
/pr-merge --dry-run
"Vérifier si la PR est prête à être fusionnée sans effectuer la fusion"
```

### Exemples de Base

```bash
# Vérification complète de la qualité et fusion
gh pr checks && gh pr view --json reviewDecision
"Vérifier le statut CI et l'état d'approbation, puis procéder à la fusion si toutes les conditions sont remplies"

# Fusion conditionnelle avec vérifications de sécurité
gh pr view --json isDraft,mergeable,reviewDecision
"Vérifier l'état de brouillon, les conflits de fusion et les approbations de révision avant la fusion"
```

### Liste de Vérification Pré-fusion

#### 1. Vérification du Statut CI
```bash
# Vérifier que tous les contrôles CI passent
gh pr checks --required
"S'assurer que tous les contrôles CI requis sont verts"
```

#### 2. Vérification du Statut de Révision
```bash
# Vérifier le statut d'approbation
gh pr view --json reviewDecision,reviews
"Vérifier que la PR a les approbations requises et aucune demande de modification en attente"
```

#### 3. Vérification du Statut de Branche
```bash
# Vérifier les conflits de fusion
gh pr view --json mergeable,mergeableState
"S'assurer qu'aucun conflit de fusion n'existe"
```

#### 4. Vérification du Statut de Brouillon
```bash
# S'assurer que la PR n'est pas en brouillon
gh pr view --json isDraft
"Confirmer que la PR est marquée comme prête pour révision"
```

### Stratégies de Fusion

#### Par Défaut : Squash et Fusion
```bash
# Fusion squash (recommandée pour les branches de fonctionnalité)
gh pr merge --squash --delete-branch
"Combiner tous les commits en un seul commit et supprimer la branche de fonctionnalité"
```

#### Alternative : Commit de Fusion
```bash
# Créer un commit de fusion (pour les branches de release)
gh pr merge --merge --delete-branch
"Créer un commit de fusion explicite préservant l'historique des commits"
```

#### Alternative : Rebase et Fusion
```bash
# Fusion rebase (pour un historique linéaire)
gh pr merge --rebase --delete-branch
"Rejouer les commits au-dessus de la branche de base"
```

### Mécanismes de Sécurité

#### 1. Conditions Requises
- ✅ Tous les contrôles CI requis doivent passer
- ✅ Au moins une approbation du propriétaire du code
- ✅ Aucune demande de modification en attente
- ✅ Aucun conflit de fusion
- ✅ La PR ne doit pas être en état de brouillon
- ✅ Règles de protection de branche satisfaites

#### 2. Critères de Qualité Optionnels
- ⚠️ Seuil de couverture de code atteint
- ⚠️ Scan de sécurité réussi
- ⚠️ Benchmarks de performance acceptables
- ⚠️ Documentation mise à jour

#### 3. Contournement d'Urgence (Admin Seulement)
```bash
# Fusion forcée avec privilèges admin (utiliser avec précaution)
/pr-merge --force --admin
"Outrepasser les règles de protection (nécessite des permissions admin)"
```

### Flux d'Exécution

```bash
#!/bin/bash

# 1. Détecter la PR actuelle
detect_current_pr() {
  local current_branch=$(git branch --show-current)
  gh pr list --head $current_branch --json number --jq '.[0].number'
}

# 2. Vérification complète
verify_merge_readiness() {
  local pr_number=$1
  
  # Vérifier le statut CI
  local ci_status=$(gh pr checks $pr_number --required --json state --jq '.[] | select(.state != "SUCCESS") | length')
  if [ $ci_status -gt 0 ]; then
    echo "❌ Les contrôles CI requis ne passent pas"
    return 1
  fi
  
  # Vérifier le statut de révision
  local review_decision=$(gh pr view $pr_number --json reviewDecision --jq '.reviewDecision')
  if [ "$review_decision" != "APPROVED" ]; then
    echo "❌ PR non approuvée (statut : $review_decision)"
    return 1
  fi
  
  # Vérifier le statut de brouillon
  local is_draft=$(gh pr view $pr_number --json isDraft --jq '.isDraft')
  if [ "$is_draft" = "true" ]; then
    echo "❌ La PR est encore en brouillon"
    return 1
  fi
  
  # Vérifier les conflits de fusion
  local mergeable=$(gh pr view $pr_number --json mergeable --jq '.mergeable')
  if [ "$mergeable" != "MERGEABLE" ]; then
    echo "❌ La PR a des conflits de fusion"
    return 1
  fi
  
  echo "✅ Toutes les conditions de fusion sont satisfaites"
  return 0
}

# 3. Exécuter la fusion
execute_merge() {
  local pr_number=$1
  local strategy=${2:-"squash"}
  
  case $strategy in
    "squash")
      gh pr merge $pr_number --squash --delete-branch
      ;;
    "merge")
      gh pr merge $pr_number --merge --delete-branch
      ;;
    "rebase")
      gh pr merge $pr_number --rebase --delete-branch
      ;;
    *)
      echo "❌ Stratégie de fusion inconnue : $strategy"
      return 1
      ;;
  esac
  
  echo "✅ PR $pr_number fusionnée avec succès"
}

# Exécution principale
main() {
  local pr_number=$(detect_current_pr)
  
  if [ -z "$pr_number" ]; then
    echo "❌ Aucune PR trouvée pour la branche actuelle"
    exit 1
  fi
  
  echo "🔍 Vérification de l'état de fusion pour la PR #$pr_number"
  
  if verify_merge_readiness $pr_number; then
    if [ "$DRY_RUN" = "true" ]; then
      echo "✅ [EXÉCUTION À BLANC] La PR #$pr_number est prête pour la fusion"
    else
      echo "🚀 Procédure de fusion en cours..."
      execute_merge $pr_number $MERGE_STRATEGY
    fi
  else
    echo "❌ La PR #$pr_number n'est pas prête pour la fusion"
    exit 1
  fi
}
```

### Options

- `--pr <numéro>` : Spécifier le numéro de PR (détection automatique depuis la branche actuelle si omis)
- `--strategy <squash|merge|rebase>` : Choisir la stratégie de fusion (par défaut : squash)
- `--dry-run` : Vérifier l'état de fusion sans effectuer la fusion
- `--force` : Outrepasser les règles de protection (admin seulement)
- `--no-delete-branch` : Conserver la branche de fonctionnalité après fusion

### Intégration avec le Flux Existant

```bash
# Flux automatisé complet
/pr-check          # Vérification de la qualité
/pr-review         # Révision complète
/pr-feedback       # Traiter les problèmes
/pr-auto-update    # Mettre à jour les métadonnées
/pr-merge          # Fusion automatique quand prêt
```

### Cas d'Usage Courants

#### 1. Finalisation de Branche de Fonctionnalité
```bash
# Après finalisation du développement
/pr-merge --strategy squash
"Squasher tous les commits de fonctionnalité en un seul commit propre"
```

#### 2. Déploiement de Correctif Urgent
```bash
# Correctif d'urgence nécessitant une fusion immédiate
/pr-merge --strategy merge
"Préserver l'historique exact des commits pour la piste d'audit"
```

#### 3. Intégration de Branche de Release
```bash
# Fusionner une branche de release avec l'historique complet
/pr-merge --strategy merge --no-delete-branch
"Intégrer la release tout en préservant la branche pour référence future"
```

### Dépannage

#### Problèmes Courants
1. **PR non approuvée** : Demander une révision aux propriétaires du code
2. **Contrôles CI en échec** : Utiliser `/pr-feedback` pour analyser et corriger
3. **Conflits de fusion** : Résoudre les conflits et mettre à jour la branche
4. **Statut de brouillon** : Utiliser `gh pr ready` pour marquer comme prêt pour révision
5. **Protection de branche manquante** : Contacter l'administrateur du dépôt

#### Récupération d'Erreur
```bash
# Si la fusion échoue, analyser le problème
gh pr view $PR_NUMBER --json mergeableState,statusCheckRollup
"Vérifier l'état détaillé de fusion et les résultats CI"

# Corriger les problèmes et réessayer
/pr-feedback && /pr-merge --dry-run
"Traiter les problèmes et vérifier avant de réessayer"
```

### Considérations de Sécurité

1. **Vérification des Permissions** : S'assurer que l'utilisateur a les permissions de fusion
2. **Protection de Branche** : Respecter toutes les règles de protection configurées
3. **Piste d'Audit** : Enregistrer toutes les actions de fusion avec attribution utilisateur
4. **Plan de Rollback** : Documenter les procédures d'annulation de fusion si nécessaire

### Notes

- **Nécessite GitHub CLI** : `gh` doit être authentifié
- **Permissions de Branche** : L'utilisateur doit avoir un accès en écriture à la branche cible
- **Règles de Protection** : Toutes les règles de protection du dépôt doivent être satisfaites
- **Notification** : Les membres de l'équipe sont notifiés via les notifications de fusion standard de GitHub