;; BitRepute - Bitcoin-Secured Social Reputation Protocol
;;
;; Summary:
;; BitRepute transforms social interaction into verifiable reputation capital,
;; enabling creators to monetize authenticity while curators earn through
;; quality validation all secured by Bitcoin's immutable foundation.
;;
;; Description:
;; BitRepute introduces a revolutionary approach to social media economics by
;; creating a trustless reputation system where every interaction builds
;; verifiable social capital. Built on Stacks and anchored to Bitcoin's
;; security, this protocol rewards genuine engagement over vanity metrics.
;;
;; Users stake STX to participate, creating skin-in-the-game dynamics that
;; discourage spam and reward quality. Content creators earn Bitcoin-backed
;; rewards based on peer validation, while curators build reputation through
;; accurate content assessment. The protocol's transparent governance and
;; anti-manipulation mechanisms ensure fair value distribution across all
;; participants, making social influence measurable, tradeable, and genuinely
;; valuable.
;;
;; Core Features:
;; - Stake-to-play mechanics preventing Sybil attacks
;; - Reputation-weighted voting system for quality curation
;; - Bitcoin-denominated rewards for high-quality content
;; - Transparent social graph with on-chain following
;; - Programmable trust scores for reputation portability

;; CONSTANTS & ERROR CODES

(define-constant CONTRACT-OWNER tx-sender)

;; Error codes with descriptive naming
(define-constant ERR-OWNER-ONLY (err u100))
(define-constant ERR-NOT-FOUND (err u101))
(define-constant ERR-ALREADY-EXISTS (err u102))
(define-constant ERR-INSUFFICIENT-FUNDS (err u103))
(define-constant ERR-UNAUTHORIZED (err u104))
(define-constant ERR-INVALID-AMOUNT (err u105))
(define-constant ERR-SELF-INTERACTION (err u106))
(define-constant ERR-ALREADY-VOTED (err u107))
(define-constant ERR-INVALID-SCORE (err u108))
(define-constant ERR-STAKE-REQUIRED (err u109))
(define-constant ERR-COOLDOWN-ACTIVE (err u110))
(define-constant ERR-INVALID-INPUT (err u111))

;; PROTOCOL CONFIGURATION

(define-data-var contract-enabled bool true)
(define-data-var min-stake-amount uint u1000000) ;; 1 STX minimum stake
(define-data-var reputation-multiplier uint u100)
(define-data-var content-reward-pool uint u0)
(define-data-var platform-fee-rate uint u50) ;; 0.5% platform fee

;; CORE DATA STRUCTURES

;; User profile with comprehensive reputation tracking
(define-map users
  principal
  {
    reputation-score: uint,
    total-content: uint,
    total-earnings: uint,
    stake-amount: uint,
    last-action-block: uint,
    verified: bool,
    join-block: uint,
  }
)

;; Content metadata with quality metrics
(define-map content
  uint
  {
    creator: principal,
    content-hash: (string-ascii 64),
    title: (string-utf8 100),
    category: (string-ascii 20),
    timestamp: uint,
    total-votes: uint,
    positive-votes: uint,
    quality-score: uint,
    reward-claimed: bool,
    stake-backing: uint,
  }
)

;; Vote records with stake weighting
(define-map votes
  {
    content-id: uint,
    voter: principal,
  }
  {
    vote-type: bool, ;; true for upvote, false for downvote
    stake-weight: uint,
    timestamp: uint,
  }
)