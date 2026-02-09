# funcao para criar o arquivo router
function routesModel {
    param (
        [string]$caminho,
        [string]$extensao
    )
    if ($extensao -eq "ts") {
        $reqERes = "req: any, res: any"
    }
    elseif ($extensao -eq "js") {
        $reqERes = "req, res"
    }

    Write-Host "Iniciando a criacao do arquivo router.$extensao...`n" -ForegroundColor Yellow
    $dadosRouter = @"
import { Router } from "express";
import UserController from "../Controllers/UserController.$extensao";
import { authMiddleware, logMiddleware, validateUser } from "../Middleware/middlewares.$extensao";

/**
 * Configuração de rotas da aplicação
 * 
 * Este arquivo define todas as rotas da API.
 * Para organizar melhor, você pode criar arquivos separados para cada recurso
 * (ex: userRoutes.$extensao, productRoutes.$extensao)
 */
const router = Router();

// Middleware global para todas as rotas
router.use(logMiddleware);

// =====================================================
// ROTAS PÚBLICAS (sem autenticação)
// =====================================================

/**
 * Rota inicial da API
 * GET /
 */
router.get("/", ($reqERes) => {
    res.json({ 
        message: "API funcionando!",
        version: "1.0.0",
        endpoints: {
            users: "/api/users"
        }
    });
});

/**
 * Health check
 * GET /health
 */
router.get("/health", ($reqERes) => {
    res.json({ 
        status: "OK",
        timestamp: new Date().toISOString()
    });
});

// =====================================================
// ROTAS DE USUÁRIOS (CRUD completo)
// =====================================================

/**
 * Lista todos os usuários
 * GET /api/users
 */
router.get("/api/users", UserController.index);

/**
 * Busca um usuário específico
 * GET /api/users/:id
 */
router.get("/api/users/:id", UserController.show);

/**
 * Cria um novo usuário
 * POST /api/users
 * Body: { name, email }
 */
router.post("/api/users", validateUser, UserController.store);

/**
 * Atualiza um usuário existente
 * PUT /api/users/:id
 * Body: { name?, email? }
 */
router.put("/api/users/:id", validateUser, UserController.update);

/**
 * Remove um usuário
 * DELETE /api/users/:id
 */
router.delete("/api/users/:id", UserController.destroy);

// =====================================================
// ROTAS PROTEGIDAS (com autenticação)
// =====================================================
// Descomente as linhas abaixo para proteger rotas com autenticação

// router.get("/api/protected", authMiddleware, ($reqERes) => {
//     res.json({ message: "Rota protegida acessada com sucesso!" });
// });

// =====================================================
// ROTA 404 - Deve ser a última rota
// =====================================================
router.use(($reqERes) => {
    res.status(404).json({
        success: false,
        message: "Rota não encontrada"
    });
});

export default router;
"@
    
    $arquivoRouter = "router.$extensao"
    $caminhoAtual = Get-Location
    $caminhoArquivoFinal = "$caminhoAtual\$caminho"
    if (Test-Path -Path "$caminhoArquivoFinal\$arquivoRouter") {
        Remove-Item -Path "$caminhoArquivoFinal\$arquivoRouter"
    }
    New-Item -Path "$caminhoArquivoFinal\$arquivoRouter" -ItemType File -Value $dadosRouter
    Write-Host "Arquivo router.$extensao criado com sucesso!`n" -ForegroundColor Green
}

Export-ModuleMember -Function routesModel
