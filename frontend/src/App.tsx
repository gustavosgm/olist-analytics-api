import { useEffect, useState } from 'react';
import {
  Box, Container, GlobalStyles, Paper, Table, TableBody, TableCell,
  TableContainer, TableHead, TableRow, Typography,
} from '@mui/material';

type Venda = {
  estado: string;
  unidades_vendidas: string;
  categoria_mais_vendida: string | null;
};

const numero = new Intl.NumberFormat('pt-BR');
const painel = { p: { xs: 2, sm: 3 }, bgcolor: '#142337', borderRadius: 3 };

const nomes: Record<string, string> = {
  cama_mesa_banho: 'Cama, mesa e banho',
  moveis_decoracao: 'Móveis e decoração',
  esporte_lazer: 'Esporte e lazer',
  beleza_saude: 'Beleza e saúde',
};

export default function App() {
  const [vendas, setVendas] = useState<Venda[] | null>(null);
  const [erro, setErro] = useState(false);

  useEffect(() => {
    const controle = new AbortController();

    async function carregar() {
      try {
        const resposta = await fetch('/vendas/por-estado', {
          signal: controle.signal,
        });
        if (!resposta.ok) throw new Error('Falha na consulta');
        const linhas: Venda[] = await resposta.json();
        setVendas(linhas);
      } catch {
        if (!controle.signal.aborted) setErro(true);
      }
    }

    void carregar();
    return () => controle.abort();
  }, []);

  if (erro) return <p role="alert">Falha ao buscar as vendas. Confira a API e atualize a página.</p>;
  if (!vendas) return <p role="status">Carregando vendas…</p>;
  if (!vendas.length) return <p>Nenhuma venda encontrada.</p>;

  // A consulta SQL já retorna os estados do maior para o menor.
  const total = vendas.reduce((soma, linha) => soma + Number(linha.unidades_vendidas), 0);
  const lider = vendas[0];
  const maximo = Number(lider.unidades_vendidas);

  return (
    <Box sx={{ minHeight: '100vh', bgcolor: '#0c1726', color: '#eff5fa' }}>
      <GlobalStyles styles={{ '#root': { width: '100%', border: 0, textAlign: 'left' } }} />

      <Container maxWidth="lg" sx={{ py: { xs: 3, md: 5 } }}>
        <Typography sx={{ color: '#83dfc7', fontWeight: 700 }}>
          Olist Analytics
        </Typography>
        <Typography component="h1" variant="h3" sx={{
          color: 'inherit', my: 2, fontWeight: 700,
          fontSize: { xs: '2rem', md: '3rem' },
        }}>
          Vendas por estado
        </Typography>

        <Box sx={{
          display: 'grid', gap: 2, mb: 3,
          gridTemplateColumns: { xs: '1fr', md: '2fr 3fr' },
        }}>
          <Paper variant="outlined" sx={painel}>
            <Typography component="h2" variant="h6" color="inherit">
              Unidades vendidas
            </Typography>
            <Typography sx={{ fontSize: '3.1rem', fontWeight: 700, color: '#83dfc7' }}>
              {numero.format(total)}
            </Typography>
            <Typography color="text.secondary">
              {vendas.length} UFs · {lider.estado} lidera com {numero.format(maximo)} unidades
            </Typography>
          </Paper>

          <Paper variant="outlined" sx={painel}>
            <Typography component="h2" variant="h6" color="inherit" sx={{ mb: 2 }}>
              Top 5 por unidades
            </Typography>
            {vendas.slice(0, 5).map((linha) => (
              <Box key={linha.estado} sx={{
                display: 'grid', gridTemplateColumns: '2rem 1fr 4rem',
                alignItems: 'center', gap: 1, mb: 1,
              }}>
                <span>{linha.estado}</span>
                <Box aria-hidden sx={{ bgcolor: '#263950', borderRadius: 1 }}>
                  <Box sx={{
                    width: `${maximo ? Number(linha.unidades_vendidas) / maximo * 100 : 0}%`,
                    height: 10, borderRadius: 1, bgcolor: '#83dfc7',
                  }} />
                </Box>
                <Box sx={{ textAlign: 'right' }}>
                  {numero.format(Number(linha.unidades_vendidas))}
                </Box>
              </Box>
            ))}
          </Paper>
        </Box>

        <Paper variant="outlined" sx={{ ...painel, p: 0, overflow: 'hidden' }}>
          <Typography component="h2" variant="h6" color="inherit" sx={{ px: 2, py: 2 }}>
            Todas as UFs
          </Typography>
          <TableContainer>
            <Table size="small" aria-label="Vendas e categoria mais vendida por estado">
              <TableHead sx={{ bgcolor: '#21344b' }}>
                <TableRow>
                  <TableCell>Estado</TableCell>
                  <TableCell align="right">Unidades vendidas</TableCell>
                  <TableCell>Categoria mais vendida</TableCell>
                </TableRow>
              </TableHead>
              <TableBody>
                {vendas.map((linha) => (
                  <TableRow hover key={linha.estado}>
                    <TableCell component="th" scope="row">{linha.estado}</TableCell>
                    <TableCell align="right">
                      {numero.format(Number(linha.unidades_vendidas))}
                    </TableCell>
                    <TableCell>
                      {linha.categoria_mais_vendida
                        ? nomes[linha.categoria_mais_vendida] ?? linha.categoria_mais_vendida.replaceAll('_', ' ')
                        : 'Sem categoria'}
                    </TableCell>
                  </TableRow>
                ))}
              </TableBody>
            </Table>
          </TableContainer>
        </Paper>
      </Container>
    </Box>
  );
}